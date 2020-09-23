class AddReferencesAndAttributesToMeasurements < ActiveRecord::Migration[6.0]
  def change
    add_reference :measurements, :subject, polymorphic: true, null: false
    remove_column :measurements, :name
    remove_column :measurements, :value_type
    remove_column :measurements, :animal_id
    remove_column :measurements, :tank_id
    remove_column :measurements, :family_id
    change_column :measurements, :value, :string, null: false
  end
end
