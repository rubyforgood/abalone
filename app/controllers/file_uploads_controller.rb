# frozen_string_literal: true

# Controller manages uploading and displaying CSVs
class FileUploadsController < ApplicationController
  # The second value for each category entry will be used to determine the
  # job class that processes the data.
  #
  # Ex: Selecting "Spawning Success" in the form will post "SpawningSuccess"
  # and process the data with a SpawningSuccessJob.
  FILE_UPLOAD_CATEGORIES = CsvImporter::CATEGORIES.map do |category|
    [category, category.delete(' ')]
  end.freeze

  def index
    @processed_files = ProcessedFile.all.order(updated_at: :desc).first(20)
  end

  def new
    @categories = [['Select One', '']] + FILE_UPLOAD_CATEGORIES
  end

  def show_processing_csv_errors
    @processed_file = ProcessedFile.find(params[:id])
    record_class = @processed_file.category.constantize
    @headers = [:validation_status] + record_class::HEADERS.keys.map(&:downcase)
    records = []
    errors_list = []
    full_path_file = Rails.root.join('storage', @processed_file.filename).to_s

    IOStreams.each_record(full_path_file) do |record|
      attrs = record
      initialized_model = @processed_file.category.constantize.new(
        attrs.merge(processed_file_id: @processed_file.id, raw: false)
      )
      initialized_model.cleanse_data!

      error_message = initialized_model&.errors&.full_message&.join(',') || ''

      campos = attrs.merge('validation_status' => error_message)
      records.push(campos)
    end
    @errors_list = errors_list
    @records = records
  end

  def show
    @processed_file = ProcessedFile.find(params[:id])
    record_class = @processed_file.category.constantize
    @headers = record_class::HEADERS.keys.map(&:downcase)
    @records = record_class.where(processed_file_id: @processed_file.id)
  end

  def upload
    @file_uploads = []

    input_files.each do |input_file|
      @file_uploads << FileUploader.new(
        category: params[:category],
        input_file: input_file
      ).process
    end
  rescue NoMethodError
    head :bad_request
  end

  private

  def input_files
    params[:input_files]
  end
end
