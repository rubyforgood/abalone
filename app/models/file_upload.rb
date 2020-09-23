class FileUpload < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  has_one_attached :file

  validates_presence_of :status
end
