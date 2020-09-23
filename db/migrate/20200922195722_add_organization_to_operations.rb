class AddOrganizationToOperations < ActiveRecord::Migration[6.0]
  def change
    add_reference :operations, :organization, foreign_key: true
  end
end
