module ImportJob

  extend ActiveSupport::Concern

  included do |base|
    attr_accessor :processed_file, :stats
    attr_reader :job_stats, :error_details

    base.extend ImportJobClassMethods
  end

  def perform(*args)
    temporary_file_id = args[0]
    temporary_file = TemporaryFile.find(temporary_file_id)
    initialize_processed_file(temporary_file_id)
    if already_processed?(temporary_file_id)
      fail_processed_file("Already processed a file from the same upload event. Data not imported!")
    else
      filename = create_temp_file_on_disk(temporary_file_id)
      full_path = Rails.root.join('storage', filename).to_s

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
  
  def create_temp_file_on_disk(temporary_file_id)
    timestamp = Time.new.strftime('%s_%N')
    filename = [timestamp, temporary_file_id].join('_') + '.csv'
    File.open(Rails.root.join('storage', filename), 'wb') do |file|
      file.write TemporaryFile.find(temporary_file_id).contents
    end

    return filename
  end
  
  def validate_headers(full_path)
    raise "No input file specified" unless full_path

    headers = CSV.parse(File.read(full_path, encoding: 'bom|utf-8'), headers: true).headers.compact
    valid_headers = category_model::HEADERS.values

    log("Headers in file: #{headers}", :debug)
    log("Valid headers for model: #{valid_headers}", :debug)
    valid_headers == headers
  end

  def import_records(filename)
    raise "No input file specified" unless filename
    csv_importer = CsvImporter.new(filename, category_model.name.underscore.humanize.titleize, @processed_file.id)
    csv_importer.call

    if csv_importer.errored?
      @error_details = csv_importer.error_details
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

  def already_processed?(filename)
    ProcessedFile.where(status: ['Processed','Processed with errors'] ).where(original_filename: original_filename(filename)).count > 0
  end

  def initialize_processed_file(temporary_file_id)
    @processed_file = ProcessedFile.new(temporary_file_id: temporary_file_id,
                                        category: category,
                                        status: 'Running')
  end

  def complete_processed_file!
    @processed_file.job_stats = job_stats
    @processed_file.status = 'Processed'
  end

  def fail_processed_file(error)
    @processed_file.status = 'Failed'
    @processed_file.job_stats = error_details || {}
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
