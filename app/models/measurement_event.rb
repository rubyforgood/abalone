class MeasurementEvent < ApplicationRecord
  include OrganizationScope

  has_many :measurements, dependent: :destroy
end
