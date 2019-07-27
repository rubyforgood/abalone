class SpawningSuccessJob < ApplicationJob

  attr_accessor :stats

  # TODO Check if a file was already uploaded
  # TODO Create a new table to track uploaded files and processing results:
  #   filename
  #   category
  #   job id
  #   completion status
  #   job stats
  #   job errors
  def perform(*args)
    filename = args[0]
    full_path = Rails.root.join('storage', filename).to_s
    initialize_stats!
    if validate_headers(full_path)
      import_records(full_path)
    else
      Rails.logger.error "Error: #{filename} does not have valid headers. Data not imported!"
    end
  end

  def validate_headers(filename)
    raise "No input file specified" unless filename
    headers = []
    IOStreams.each_row(filename) do |row|
      headers = row
      break
    end
    valid_headers = SpawningSuccess::HEADERS.values
    valid_headers == headers
  end

  def import_records(filename)
    raise "No input file specified" unless filename
    IOStreams.each_record(filename) do |record|
      attrs = translate_attribute_names(record)
      spawning_success = SpawningSuccess.new(attrs.merge({raw: false}))
      spawning_success.cleanse_data!
      unless spawning_success.save
        Rails.logger.error "Error: Row #{@stats[:row_count]+2} is not valid. #{attrs}"
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
end