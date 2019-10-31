# frozen_string_literal: true

class CreatePedigrees < ActiveRecord::Migration[5.2]
  def change
    create_table :pedigrees do |t|
      t.boolean :raw, null: false, default: true
      t.string :cohort
      t.string :shl_case_number
      t.date :spawning_date
      t.string :mother
      t.string :father
      t.string :seperate_cross_within_cohort

      t.timestamps
    end
  end
end
