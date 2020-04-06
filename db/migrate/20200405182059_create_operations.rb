class CreateOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :operations do |t|
      t.belongs_to :tank, foreign_key: true
      t.integer :animals_added
      t.integer :animals_added_family_id

      t.timestamps
    end
  end
end
