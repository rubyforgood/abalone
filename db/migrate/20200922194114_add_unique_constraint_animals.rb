class AddUniqueConstraintAnimals < ActiveRecord::Migration[6.0]
  def change
    add_index :animals, [:pii_tag, :organization_id], unique: true
  end
end
