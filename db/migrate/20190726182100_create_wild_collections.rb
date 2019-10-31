# frozen_string_literal: true

class CreateWildCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :wild_collections do |t|
      t.boolean :raw, null: false, default: true
      t.string :tag
      t.date :collection_date
      t.string :general_location
      t.string :precise_location
      t.point :collection_coodinates
      t.string :proximity_to_nearest_neighbor
      t.string :collection_method_notes
      t.string :foot_condition_notes
      t.string :collection_depth
      t.string :length
      t.string :weight
      t.string :gonad_score
      t.string :predicted_sex
      t.string :initial_holding_facility
      t.string :final_holding_facility_date_of_arrival
      t.string :otc_treatment_completion_date

      t.timestamps
    end
  end
end
