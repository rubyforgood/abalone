class CreatePostSettlementInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :post_settlement_inventories do |t|
      t.datetime :inventory_date
      t.integer :mean_standard_length
      t.integer :total_per_tank
      t.references :tank, foreign_key: true
    end
  end
end

