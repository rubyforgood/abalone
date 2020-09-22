class AddOrganizationToTanks < ActiveRecord::Migration[6.0]
  def change
    add_reference :tanks, :organization, foreign_key: true
  end
end
