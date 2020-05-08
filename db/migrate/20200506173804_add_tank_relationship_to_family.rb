class AddTankRelationshipToFamily < ActiveRecord::Migration[5.2]
  def change
    change_table :families do |table|
      table.references :tank, index: true, null: true
    end
  end
end
