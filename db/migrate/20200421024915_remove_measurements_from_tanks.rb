class RemoveMeasurementsFromTanks < ActiveRecord::Migration[5.2]
  def change
    remove_reference :measurements, :tank, foreign_key: true
  end
end
