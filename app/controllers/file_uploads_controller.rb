class FileUploadsController < ApplicationController

  CATEGORIES = [
      'Spawning Success',
      # 'Tagged Animal Assessment',
      # 'Untagged Animal Assessment',
      # 'Wild Collection'
  ].freeze

  def index
  end

  def new
    @categories = [['Select One', '']] + CATEGORIES.map{|c| [c,c]}
  end

  def upload

    @result = 'Error: Invalid category!' unless CATEGORIES.include?(@category)
    @category = params[:category]
    uploaded_io = params[:input_file]
    timestamp = Time.new.strftime('%s_%N')
    if uploaded_io
      @filename = [timestamp, uploaded_io.original_filename].join('_')
      File.open(Rails.root.join('storage', @filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end

      if @category == 'Spawning Success'
        @reference = SpawnsJob.perform_later(@filename)
        @result = "Successfully queued spreadsheet for import."
      end
    else
      @result = 'Error: No file uploaded.'
    end
  end

end
