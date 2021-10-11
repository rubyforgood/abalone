class FixVersionsTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :versions, "{:null=>false}"

    change_column_null :versions, :item_type, false
  end
end
