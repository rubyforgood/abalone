class CreateAnimals < ActiveRecord::Migration[5.2]
  def change
    create_table :animals do |t|
      t.integer :collection_year
      t.datetime :date_time_collected
      t.string :collection_position
      t.integer :pii_tag
      t.integer :tag_id
      t.string :sex

      t.timestamps
    end
  end
end
