class MeasurementType < ApplicationRecord
  include OrganizationScope

  has_many :measurements
end
