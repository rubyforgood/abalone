class AddOrganizationToMortalityEvent < ActiveRecord::Migration[6.1]
  def change
    add_reference :mortality_events, :organization, foreign_key: true
  end
end
