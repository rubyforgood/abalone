class AddMeasurementDateToMeasurements < ActiveRecord::Migration[5.2]
  def change
    add_column :measurements, :date, :datetime
  end
end
