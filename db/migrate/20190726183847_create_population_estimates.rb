# frozen_string_literal: true

class CreatePopulationEstimates < ActiveRecord::Migration[5.2]
  def change
    create_table :population_estimates do |t|
      t.boolean :raw, null: false, default: true
      t.date :sample_date
      t.string :shl_number
      t.date :spawning_date
      t.string :lifestage
      t.string :abundance
      t.string :facility
      t.string :notes

      t.timestamps
    end
  end
end
