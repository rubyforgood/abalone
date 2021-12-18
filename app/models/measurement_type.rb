class MeasurementType < ApplicationRecord
  include OrganizationScope

  has_many :measurements, dependent: :restrict_with_error

  validates :name, :unit, presence: true
end
