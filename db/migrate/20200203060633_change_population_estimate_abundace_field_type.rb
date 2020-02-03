class ChangePopulationEstimateAbundaceFieldType < ActiveRecord::Migration[5.2]
  def change
    change_column :population_estimates, :abundance, "integer USING abundance::integer"
  end
end
