class ChangeFamiliesToCohort < ActiveRecord::Migration[6.0]
  def change
    rename_column :operations, :family_id, :cohort_id
    rename_table :families, :cohorts
  end
end
