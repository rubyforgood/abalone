class CreateMeasurementEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :measurement_events do |t|
      t.string :name
      t.references :tank, foreign_key: true

      t.timestamps
    end

    change_table :measurements do |t|
      t.references :measurement_event, foreign_key: true
    end
  end
end
