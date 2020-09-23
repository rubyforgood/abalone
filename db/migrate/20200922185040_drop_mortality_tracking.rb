class DropMortalityTracking < ActiveRecord::Migration[6.0]
  def up
    drop_table :mortality_trackings
  end

  def down; end
end
