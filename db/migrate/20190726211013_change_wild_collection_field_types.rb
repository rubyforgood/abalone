# frozen_string_literal: true

class ChangeWildCollectionFieldTypes < ActiveRecord::Migration[5.2]
  def change
    change_column :wild_collections, :collection_depth, 'numeric USING collection_depth::numeric'
    change_column :wild_collections, :length, 'numeric USING collection_depth::numeric'
    change_column :wild_collections, :weight, 'numeric USING collection_depth::numeric'
    change_column :wild_collections, :otc_treatment_completion_date, 'date USING otc_treatment_completion_date::date'
    rename_column :wild_collections, :final_holding_facility_date_of_arrival, :final_holding_facility_and_date_of_arrival
  end
end
