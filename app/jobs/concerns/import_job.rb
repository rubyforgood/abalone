module ImportJob
  extend ActiveSupport::Concern

  included do |base|
    attr_accessor :processed_file, :stats
    attr_reader :job_stats, :error_details, :filename, :error_messages

    base.extend ImportJobClassMethods
  end

  def perform(*args)
    temporary_file = args[0]
    @filename = args[1]
    @organization = args[2]
    initialize_processed_file(temporary_file, filename, @organization)
    if already_processed?
      fail_processed_file("Already processed a file on #{already_processed_file.first.created_at.strftime('%m/%d/%Y')} with the same name: #{filename}. Data not imported!")
    elsif validate_headers(temporary_file)
      if import_records(temporary_file)
        complete_processed_file!
      else
        log("Error: #{filename} does not have valid row(s). Data not imported!", :error)
        fail_processed_file("Does not have valid row(s). Data not imported!")
      end
    else
      log("Error: #{filename} does not have valid header(s). Data not imported!", :error)
      fail_processed_file("Does not have valid header(s). Data not imported!")
    end

    @processed_file.save
  end

  def validate_headers(temporary_file)
    raise "No input file specified" unless temporary_file

    headers = CSV.parse(temporary_file.contents, headers: true, header_converters: ->(header) { CsvImporter.header_conversion(header) }).headers.compact
    valid_headers = category_model::HEADERS.map { |header| CsvImporter.header_conversion(header) }

    log("Headers in file: #{headers}", :debug)
    log("Valid headers for model: #{valid_headers}", :debug)
    valid_headers == headers
  end

  def import_records(temporary_file)
    raise "No input file specified" unless temporary_file

    csv_importer = CsvImporter.new(temporary_file.contents, category_model.name.underscore.humanize.titleize, @processed_file.id, @organization)
    csv_importer.call

    if csv_importer.errored?
      @error_details = csv_importer.error_details
      @error_messages = csv_importer.error_messages
      log(error_details, :info)
      return false
    end

    @job_stats = csv_importer.stats
    log(job_stats, :info)
    true
  end

  def category
    self.class.category
  end

  def category_model
    @category_model ||= category.constantize
  end

  def already_processed?
    already_processed_file.count > 0
  end

  def already_processed_file
    @already_processed_file ||= ProcessedFile.where(status: ['Processed', 'Processed with errors'])
                                             .where(filename: filename)
  end

  def initialize_processed_file(temporary_file, filename, organization)
    @processed_file = ProcessedFile.create(temporary_file_id: temporary_file.id,
                                           filename: filename,
                                           category: category,
                                           organization: organization,
                                           status: 'Running')
  end

  def complete_processed_file!
    @processed_file.job_stats = job_stats
    @processed_file.status = 'Processed'
  end

  def fail_processed_file(error)
    @processed_file.status = 'Failed'
    @processed_file.job_stats = error_details || {}
    @processed_file.job_errors = format_errors(error)
  end

  def format_errors(error)
    return error if error_messages.nil? || error_messages.empty?

    total_lines = error_messages.keys.length
    total_errors = error_messages.values.map(&:length).reduce(:+)
    messages = error_messages.map { |row, row_errors| "#{row} : #{row_errors.join(', ')}" }
    "#{error} #{total_errors} error(s) found on #{total_lines} row(s). #{messages.join('. ')}."
  end

  def logger
    @logger ||= Delayed::Worker.logger
  end

  def log(message, level = :debug)
    raise "Wrong logger level: #{level}" unless %i(debug error info).include?(level)

    logger.send(level, message)
  end

  module ImportJobClassMethods
    def category
      @category ||= to_s.gsub(/Job/, '')
    end
  end
end
