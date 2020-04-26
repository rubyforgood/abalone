class MeasurementEvent < ApplicationRecord
  belongs_to :tank, optional: true
  has_many :measurements
end
