# frozen_string_literal: true

class AddProcessedFileIdToData < ActiveRecord::Migration[5.2]
  def change
    add_column :spawning_successes, :processed_file_id, :integer
    add_column :wild_collections, :processed_file_id, :integer
    add_column :mortality_trackings, :processed_file_id, :integer
    add_column :population_estimates, :processed_file_id, :integer
    add_column :pedigrees, :processed_file_id, :integer
    add_column :untagged_animal_assessments, :processed_file_id, :integer
    add_column :tagged_animal_assessments, :processed_file_id, :integer
  end
end
