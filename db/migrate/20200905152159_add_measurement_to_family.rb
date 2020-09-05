class AddMeasurementToFamily < ActiveRecord::Migration[5.2]
  def change
    add_reference :families, :measurement, foreign_key: true
  end
end
