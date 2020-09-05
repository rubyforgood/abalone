class AddAnimalFamilyTankToMeasurement < ActiveRecord::Migration[5.2]
  def change
    add_reference :measurements, :animal, foreign_key: true
    add_reference :measurements, :family, foreign_key: true
    add_reference :measurements, :tank, foreign_key: true
  end
end
