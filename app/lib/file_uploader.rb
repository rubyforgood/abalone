# Takes in CSV files and creates background jobs to process them
class FileUploader
  attr_accessor :category, :input_file, :filename, :reference, :result_message

  FILE_UPLOAD_CATEGORIES = CsvImporter::CATEGORIES.map {|category| [category, category.delete(' ')] }.freeze

  def initialize(category:, input_file:)
    @category = category
    @input_file = input_file
  end

  def process
    if FILE_UPLOAD_CATEGORIES.map{|label,value| value}.include?(self.category)
      queue_spreadsheet
    else
      self.result_message = 'Error: Invalid category!'
    end

    return self
  end

  def queue_spreadsheet
    timestamp = Time.new.strftime('%s_%N')

    begin
      temporary_file = TemporaryFile.create(contents: input_file.read)
      self.filename = input_file.original_filename
      job_class = [self.category,'Job'].join
      reference = job_class.constantize.perform_later(temporary_file, self.filename)
      self.result_message = "Successfully queued spreadsheet for import as a #{job_class}."
    rescue Exception => e
      self.result_message = "Error: File could not be uploaded: #{e.message}"
    end
  end
end
