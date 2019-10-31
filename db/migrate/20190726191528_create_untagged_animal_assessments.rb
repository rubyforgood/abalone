# frozen_string_literal: true

class CreateUntaggedAnimalAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :untagged_animal_assessments do |t|
      t.boolean :raw, null: false, default: true
      t.date :measurement_date
      t.string :cohort
      t.date :spawning_date
      t.numeric :growout_rack
      t.string :growout_column
      t.numeric :growout_trough
      t.numeric :length
      t.numeric :mass
      t.string :gonad_score
      t.string :predicted_sex
      t.text :notes

      t.timestamps
    end
  end
end
