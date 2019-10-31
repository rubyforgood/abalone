# frozen_string_literal: true

class FileUploadsController < ApplicationController
  # The second value for each category entry will be used to determine the job class that processes the data.
  # Ex: Selecting "Spawning Success" in the form will post "SpawningSuccess" and process the data with a SpawningSuccessJob.
  CATEGORIES = [
    ['Spawning Success', 'SpawningSuccess'],
    ['Tagged Animal Assessment', 'TaggedAnimalAssessment']
    # ['Untagged Animal Assessment', 'UntaggedAnimalAssessment'],
    # ['Wild Collection','WildCollection']
  ].freeze

  def index
    @processed_files = ProcessedFile.all.order(updated_at: :desc).first(20)
  end

  def new
    @categories = [['Select One', '']] + CATEGORIES
  end

  def show
    if @processed_file = ProcessedFile.find(params['id'])
      record_class = @processed_file.category.constantize
      @headers = record_class::HEADERS.keys.map(&:downcase)
      @records = record_class.where(processed_file_id: @processed_file.id)
    end
  end

  def upload
    @category = params[:category]
    if CATEGORIES.map { |_label, value| value }.include?(@category)
      uploaded_io = params[:input_file]
      timestamp = Time.new.strftime('%s_%N')
      if uploaded_io
        @filename = [timestamp, uploaded_io.original_filename].join('_')
        File.open(Rails.root.join('storage', @filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end

        job_class = [@category, 'Job'].join
        @reference = job_class.constantize.perform_later(@filename)
        @result = "Successfully queued spreadsheet for import as a #{job_class}."
      else
        @result = 'Error: No file uploaded.'
      end
    else
      @result = 'Error: Invalid category!'
    end
  end
end
