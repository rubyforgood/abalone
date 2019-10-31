# frozen_string_literal: true

class CreateTaggedAnimalAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :tagged_animal_assessments do |t|
      t.boolean :raw, null: false, default: true
      t.date :measurement_date
      t.string :shl_case_number
      t.date :spawning_date
      t.string :tag
      t.string :from_growout_rack
      t.string :from_growout_column
      t.string :from_growout_trough
      t.string :to_growout_rack
      t.string :to_growout_column
      t.string :to_growout_trough
      t.numeric :length
      t.string :gonad_score
      t.string :predicted_sex
      t.text :notes

      t.timestamps
    end
  end
end
