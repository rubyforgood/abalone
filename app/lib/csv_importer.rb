class CsvImporter
  attr_reader :stats, :category_name, :temporary_file, :processed_file_id, :error_details, :error_messages, :organization

  CATEGORIES_MAPPED_TO_MODELS = {
    'measurement' => {
      'length' => Measurement,
      'count' => Measurement,
      'weight' => Measurement,
      'gonad score' => Measurement,
      'animal mortality event' => MortalityEvent,
      'cohort mortality event' => MortalityEvent
    }
  }.freeze
  CATEGORIES = CATEGORIES_MAPPED_TO_MODELS.keys.map(&:titleize).freeze

  class InvalidCategoryError < StandardError; end

  def self.header_conversion(header)
    header&.strip&.downcase&.gsub(' ', '_')&.gsub(/[^a-z0-9_]/, '')&.gsub(/_+/, '_')&.gsub(/^_+/, '')
  end

  def initialize(temporary_file, category_name, processed_file_id, organization = nil)
    @temporary_file = temporary_file
    @processed_file_id = processed_file_id
    @category_name = category_name
    @stats = Hash.new(0)
    @organization = organization
    @error_details = {}
    @error_messages = {}
    @stats[:shl_case_numbers] = Hash.new(0)
  end

  def call
    process
  end

  def errored?
    !error_details.empty?
  end

  private

  def process
    row_number = 2 # assuming 1 is headers

    ActiveRecord::Base.transaction do
      CSV.parse(
        temporary_file,
        headers: true,
        header_converters: ->(header) { CsvImporter.header_conversion(header).to_sym },
        converters: ->(value) { value&.strip },
        skip_lines: /^\s*$/
      ).each do |csv_row|
        csv_row[:processed_file_id] = processed_file_id
        csv_row[:raw] = false
        model = model_from(category_name, csv_row[:measurement_type])

        record = model.create_from_csv_data(create_attributes(csv_row.to_h))
        record.cleanse_data! if record.respond_to?(:cleanse_data!)

        if record.valid?
          record.save!
          increment_stats(record)
        else
          error_details["row_number_#{row_number}"] = record.errors.details
          error_messages["Row #{row_number}"] = record.errors.full_messages
        end

        row_number += 1
      end

      unless error_details.empty?
        @stats = Hash.new(0)
        raise ActiveRecord::Rollback
      end
    end
  end

  def model_from(category_name, type)
    category = CATEGORIES_MAPPED_TO_MODELS.dig(category_name.downcase, type.downcase)

    raise InvalidCategoryError if category.nil?

    category
  end

  def increment_stats(model)
    stats[:row_count] += 1
    if model.persisted?
      stats[:rows_imported] += 1
      stats[:shl_case_numbers][model.shl_case_number] += 1 if model.respond_to?(:shl_case_number)
    else
      stats[:rows_not_imported] += 1
    end
  end

  def create_attributes(row_hash)
    return row_hash unless organization

    row_hash.merge(organization_id: organization.id)
  end
end
