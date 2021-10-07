class UpdateAnimalsColumnNames < ActiveRecord::Migration[6.1]
  def up
    rename_column :animals, :collection_year, :entry_year
    rename_column :animals, :date_time_collected, :entry_date
    rename_column :animals, :collection_position, :entry_point
  end
  
  def down
    rename_column :animals, :entry_year, :collection_year
    rename_column :animals, :entry_date, :date_time_collected
    rename_column :animals, :entry_point, :collection_position
  end
end
