class AddOrgIndexes < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :organization, index: true
    add_reference :facilities, :organization, index: true
  end
end
