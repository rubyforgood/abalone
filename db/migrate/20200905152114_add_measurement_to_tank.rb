class AddMeasurementToTank < ActiveRecord::Migration[5.2]
  def change
    add_reference :tanks, :measurement, foreign_key: true
  end
end
