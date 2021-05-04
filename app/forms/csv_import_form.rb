class CsvImportForm
  include ActiveModel::Model

  attr_accessor :csv_file

  validates :csv_file, presence: true

  def save(user:, organization:)
    valid_form? && ImportCohortsJob.perform_later(
      FileUpload.create(user: user, organization: organization, status: 'Pending', file: csv_file)
    )
  end

  private

  def valid_form?
    valid? && valid_content_type?
  end

  def valid_content_type?
    return true if csv_file&.content_type == 'text/csv'

    errors.add :csv_file, 'Invalid file type. Please upload a CSV.'
    false
  end
end
