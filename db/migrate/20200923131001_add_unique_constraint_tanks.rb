class AddUniqueConstraintTanks < ActiveRecord::Migration[6.0]
  def change
    add_index :tanks, [:name, :facility_id, :organization_id], unique: true
  end
end
