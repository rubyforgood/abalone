# Takes in CSV files and creates background jobs to process them
class FileUploader
  attr_accessor :category, :input_file, :filename, :reference, :result_message, :organization

  FILE_UPLOAD_CATEGORIES = CsvImporter::CATEGORIES.map { |category| [category, category.delete(' ')] }.freeze

  def initialize(category:, input_file:, organization:)
    @category = category
    @organization = organization
    @input_file = input_file
  end

  def process
    if FILE_UPLOAD_CATEGORIES.map { |_label, value| value }.include?(category)
      queue_spreadsheet
    else
      self.result_message = 'Error: Invalid category!'
    end

    self
  end

  def queue_spreadsheet
    temporary_file = TemporaryFile.create(contents: input_file.read)
    self.filename = input_file.original_filename
    job_class = [category, 'Job'].join
    job_class.constantize.perform_later(temporary_file, filename, organization)
    self.result_message = "Successfully queued spreadsheet for import as a #{job_class}."
  rescue StandardError => e
    self.result_message = "Error: File could not be uploaded: #{e.message}"
  end
end
