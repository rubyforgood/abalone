class DropPopulationEstimates < ActiveRecord::Migration[6.0]
  def up
    drop_table :population_estimates
  end

  def down; end
end
