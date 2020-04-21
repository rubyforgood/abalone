class Measurement < ApplicationRecord
  belongs_to :measurement_event

  delegate :tank, to: :measurement_event
  def self.create_from_csv_data(attrs)
    new(attrs)
  end
end
