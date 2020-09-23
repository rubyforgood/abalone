class ChangeTanksToEnclosures < ActiveRecord::Migration[6.0]
  def change
    rename_table :tanks, :enclosures
    rename_column :cohorts, :tank_id, :enclosure_id
    rename_column :operations, :tank_id, :enclosure_id
  end
end
