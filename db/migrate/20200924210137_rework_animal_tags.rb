class ReworkAnimalTags < ActiveRecord::Migration[6.0]
  def change
    remove_column :animals, :pii_tag
    remove_column :animals, :tag_id
    add_column :animals, :tag, :string, null: true
    add_index :animals, [:tag, :cohort_id], unique: true
  end
end
