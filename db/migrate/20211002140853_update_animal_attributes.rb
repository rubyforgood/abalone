class UpdateAnimalAttributes < ActiveRecord::Migration[6.1]
  def change
    rename_column :animals, :collection_year, :entry_year
    rename_column :animals, :date_time_collected, :entered_at
    rename_column :animals, :collection_position, :entry_point
  end
end
