class CreateMeasurements < ActiveRecord::Migration[5.2]
  def change
    create_table :measurements do |t|
      t.string :name
      t.string :value_type
      t.jsonb :value
      t.belongs_to :tank, foreign_key: true

      t.timestamps
    end
  end
end
