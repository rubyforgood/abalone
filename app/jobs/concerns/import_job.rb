module ImportJob

  extend ActiveSupport::Concern

  included do |base|
    attr_accessor :processed_file, :stats
    attr_reader :job_stats

    base.extend ImportJobClassMethods
  end

  def perform(*args)
    filename = args[0]
    full_path = Rails.root.join('storage', filename).to_s
    initialize_processed_file(filename)

    if already_processed?(filename)
      fail_processed_file("Already processed a file with the same name. Data not imported!")
    else
      if validate_headers(full_path)
        if import_records(full_path)
          complete_processed_file!
          remove_file!(filename)
        else
          log("Error: #{filename} does not have valid row(s). Data not imported!", :error)
          fail_processed_file("Does not have valid row(s). Data not imported!")
        end
      else
        log("Error: #{filename} does not have valid header(s). Data not imported!", :error)
        fail_processed_file("Does not have valid header(s). Data not imported!")
      end
    end

    @processed_file.save
  end

  def validate_headers(filename)
    raise "No input file specified" unless filename

    headers = CSV.parse(File.read(filename, encoding: 'bom|utf-8'), headers: true)
      .headers
      .compact
    valid_headers = category_model::HEADERS.values

    log("Headers in file: #{headers}", :debug)
    log("Valid headers for model: #{valid_headers}", :debug)
    valid_headers == headers
  end

  def import_records(filename)
    raise "No input file specified" unless filename
    csv_importer = CsvImporter.new(filename, category_model.name.underscore.humanize.titleize, @processed_file.id)
    csv_importer.call

    if csv_importer.erred?
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

  def already_processed?(filename)
    ProcessedFile.where(status: ['Processed','Processed with errors'] ).where(original_filename: original_filename(filename)).count > 0
  end

  def initialize_processed_file(filename)
    @processed_file = ProcessedFile.new(filename: filename,
                                        original_filename: original_filename(filename),
                                        category: category,
                                        status: 'Running')
  end

  def complete_processed_file!
    @processed_file.job_stats = job_stats
    @processed_file.status = 'Processed'
  end

  def fail_processed_file(error)
    @processed_file.status = 'Failed'
    @processed_file.job_stats = {}
    @processed_file.job_errors = error
  end

  # Remove the prepended timestamp.
  # original_filename('1564252385_859395139_spawn_newheaders.xlsx') returns 'spawn_newheaders.xlsx'
  def original_filename(filename)
    /\d+_\d+_(.+)?/.match(filename.to_s)&.captures&.first
  end

  def remove_file!(filename)
    Rails.root.join('storage', filename).delete
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
