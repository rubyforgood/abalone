class FileUploadsController < ApplicationController

  # The second value for each category entry will be used to determine the job class that processes the data.
  # Ex: Selecting "Spawning Success" in the form will post "SpawningSuccess" and process the data with a SpawningSuccessJob.
  FILE_UPLOAD_CATEGORIES = CsvImporter::CATEGORIES.map {|category| [category, category.delete(' ')] }.freeze

  def index
    @processed_files = ProcessedFile.all.order(updated_at: :desc).first(20)
  end

  def new
    @categories = [['Select One', '']] + FILE_UPLOAD_CATEGORIES
  end

  def show_processing_csv_errors
    if @processed_file = ProcessedFile.find(params['id'])
      record_class = @processed_file.category.constantize
      @headers = [:validation_status].concat record_class::HEADERS.keys.map{|header| header.downcase}
      records = []
      errors_list = Array.new
      full_path_file = Rails.root.join('storage', @processed_file.filename).to_s

      IOStreams.each_record(full_path_file) do |record|
        attrs = record
        spawning_success = @processed_file.category.constantize.new(
            attrs.merge({processed_file_id: @processed_file.id, raw: false})
        )
        spawning_success.cleanse_data!
        error_message = spawning_success.valid? ? '' : spawning_success.errors.full_messages.join(",")
        campos = attrs.merge ({ 'validation_status' => error_message})
        records.push(campos)
      end
      @errors_list = errors_list
      @records = records
    end
  end

  def show
    if @processed_file = ProcessedFile.find(params['id'])
      record_class = @processed_file.category.constantize
      @headers = record_class::HEADERS.keys.map{|header| header.downcase}
      @records = record_class.where(processed_file_id: @processed_file.id)
    end
  end

  def upload
    @category = params[:category]
    if FILE_UPLOAD_CATEGORIES.map{|label,value| value}.include?(@category)
      uploaded_io = params[:input_file]
      timestamp = Time.new.strftime('%s_%N')
      if uploaded_io
        begin
          temporary_file = TemporaryFile.create(contents: uploaded_io.read)
        rescue Exception => e
          @result = "Error: File could not be uploaded: #{e.message}"
        end
        job_class = [@category,'Job'].join
        @reference = job_class.constantize.perform_later(temporary_file.id)
        @result = "Successfully queued spreadsheet for import as a #{job_class}."
      else
        @result = 'Error: No file uploaded.'
      end
    else
      @result = 'Error: Invalid category!'
    end
  end
end
