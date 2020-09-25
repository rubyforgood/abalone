class MeasurementType < ApplicationRecord
  include OrganizationScope

  has_many :measurements

  validates :name, :unit, presence: true
end
