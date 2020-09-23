class DropWildCollections < ActiveRecord::Migration[6.0]
  def up
    drop_table :wild_collections
  end

  def down; end
end
