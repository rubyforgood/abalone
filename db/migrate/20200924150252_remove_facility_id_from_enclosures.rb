class RemoveFacilityIdFromEnclosures < ActiveRecord::Migration[6.0]
  def change
    remove_column :enclosures, :facility_id, :integer
  end
end
