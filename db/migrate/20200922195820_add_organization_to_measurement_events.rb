class AddOrganizationToMeasurementEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference :measurement_events, :organization, foreign_key: true
  end
end
