class MeasurementEvent < ApplicationRecord
  belongs_to :tank
  has_many :measurements
end
