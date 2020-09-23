class FileUpload < ApplicationRecord
  include OrganizationScope
  belongs_to :user
  has_one_attached :file

  validates_presence_of :status
end
