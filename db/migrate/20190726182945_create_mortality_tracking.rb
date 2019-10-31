# frozen_string_literal: true

class CreateMortalityTracking < ActiveRecord::Migration[5.2]
  def change
    create_table :mortality_trackings do |t|
      t.boolean :raw, default: true, null: false
      t.date :mortality_date
      t.string :cohort
      t.string :shl_case_number
      t.date :spawning_date
      t.integer :shell_box
      t.string :shell_container
      t.string :animal_location
      t.integer :number_morts
      t.string :approximation
      t.string :processed_by_shl
      t.string :initials
      t.string :tags
      t.string :comments

      t.timestamps
    end
  end
end
