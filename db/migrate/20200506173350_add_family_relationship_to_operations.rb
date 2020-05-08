class AddFamilyRelationshipToOperations < ActiveRecord::Migration[5.2]
  def change
    change_table :operations do |table|
      table.references :family, index: true
    end
  end
end
