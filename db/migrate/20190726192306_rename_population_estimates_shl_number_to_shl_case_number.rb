# frozen_string_literal: true

class RenamePopulationEstimatesShlNumberToShlCaseNumber < ActiveRecord::Migration[5.2]
  def change
    rename_column :population_estimates, :shl_number, :shl_case_number
  end
end
