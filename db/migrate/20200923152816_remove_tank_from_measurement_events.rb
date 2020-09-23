class RemoveTankFromMeasurementEvents < ActiveRecord::Migration[6.0]
  def change
    remove_column :measurement_events, :tank_id
  end
end
