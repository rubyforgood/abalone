class DropPostSettlementInventories < ActiveRecord::Migration[6.0]
  def up
    drop_table :post_settlement_inventories
  end

  def down; end
end
