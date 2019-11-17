class FixColumnTypo < ActiveRecord::Migration[5.2]
  def change
    rename_column :wild_collections, :collection_coodinates, :collection_coordinates
  end
end
