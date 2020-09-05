class AddMeasurementToAnimal < ActiveRecord::Migration[5.2]
  def change
    add_reference :animals, :measurement, foreign_key: true
  end
end
