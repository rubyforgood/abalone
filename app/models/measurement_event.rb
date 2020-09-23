class MeasurementEvent < ApplicationRecord
  include OrganizationScope

  belongs_to :tank, optional: true
  has_many :measurements, dependent: :destroy
end
