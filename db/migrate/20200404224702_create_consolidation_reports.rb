class CreateConsolidationReports < ActiveRecord::Migration[5.2]
  def change
    create_table :consolidation_reports do |t|
      t.references :family, foreign_key: true
      t.references :tank_from, foreign_key: true
      t.references :tank_to, foreign_key: true
      t.string :total_animal

      t.timestamps
    end
  end
end