class CreateMeasurementTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :measurement_types do |t|
      t.string :name # count || length
      t.string :unit # integer || cm
      t.references :organization

      t.timestamps
    end
  end
end
