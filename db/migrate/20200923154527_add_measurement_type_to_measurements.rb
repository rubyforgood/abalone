class AddMeasurementTypeToMeasurements < ActiveRecord::Migration[6.0]
  def change
    add_reference :measurements, :measurement_type
  end
end
