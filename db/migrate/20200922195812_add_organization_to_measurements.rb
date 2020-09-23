class AddOrganizationToMeasurements < ActiveRecord::Migration[6.0]
  def change
    add_reference :measurements, :organization, foreign_key: true
  end
end
