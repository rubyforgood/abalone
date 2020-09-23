class DropConsolidationReportsTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :consolidation_reports
  end

  def down; end
end
