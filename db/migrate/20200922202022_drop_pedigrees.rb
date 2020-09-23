class DropPedigrees < ActiveRecord::Migration[6.0]
  def up
    drop_table :pedigrees
  end

  def down; end
end
