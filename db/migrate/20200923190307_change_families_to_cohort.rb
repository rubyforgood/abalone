class ChangeFamiliesToCohort < ActiveRecord::Migration[6.0]
  def change
    rename_table :families, :cohorts
    rename_column :operations, :family_id, :cohort_id
    rename_column :operations, :animals_added_family_id, :animals_added_cohort_id
  end
end
