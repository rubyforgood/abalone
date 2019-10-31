# frozen_string_literal: true

class SpawningSuccessJob < ApplicationJob
  attr_accessor :processed_file, :stats

  def perform(*args)
    filename = args[0]
    full_path = Rails.root.join('storage', filename).to_s
    initialize_stats!
    initialize_processed_file(filename)
    if already_processed?(filename)
      fail_processed_file('Already processed a file with the same name. Data not imported!')
    else
      if validate_headers(full_path)
        import_records(full_path)
        complete_processed_file!
      else
        Rails.logger.error "Error: #{filename} does not have valid headers. Data not imported!"
        fail_processed_file('Does not have valid headers. Data not imported!')
      end
    end
    remove_file!(filename)
    @processed_file.save
  end

  def validate_headers(filename)
    raise 'No input file specified' unless filename

    headers = []
    IOStreams.each_row(filename) do |row|
      headers = row
      break
    end
    valid_headers = SpawningSuccess::HEADERS.values
    valid_headers == headers
  end

  def import_records(filename)
    raise 'No input file specified' unless filename

    IOStreams.each_record(filename) do |record|
      attrs = translate_attribute_names(record)
      spawning_success = SpawningSuccess.new(
        attrs.merge(processed_file_id: @processed_file.id, raw: false)
      )
      spawning_success.cleanse_data!
      unless spawning_success.save
        Rails.logger.error "Error: Row #{@stats[:row_count] + 2} is not valid. #{attrs}"
      end
      increment_stats(attrs, spawning_success.persisted?)
    end
    Rails.logger.info @stats
  end

  private

  def initialize_stats!
    @stats = Hash.new(0)
    @stats[:shl_case_numbers] = Hash.new(0)
  end

  def increment_stats(attrs, persisted)
    @stats[:row_count] += 1
    if persisted
      @stats[:rows_imported] += 1
      @stats[:shl_case_numbers][attrs['shl_case_number']] += 1
    else
      @stats[:rows_not_imported] += 1
    end
  end

  def translate_attribute_names(attrs)
    attrs['nbr_of_eggs_spawned'] = attrs.delete('number_of_eggs_spawned_if_female')
    attrs
  end

  def already_processed?(filename)
    ProcessedFile
      .where(status: 'Processed')
      .where(original_filename: original_filename(filename))
      .exists?
  end

  def initialize_processed_file(filename)
    @processed_file = ProcessedFile.create(filename: filename,
                                           original_filename: original_filename(filename),
                                           category: self.class.to_s.gsub(/Job/, ''),
                                           status: 'Running',
                                           job_stats: @stats)
  end

  def complete_processed_file!
    @processed_file.job_stats = @stats
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
end
