class AddLocationIdToEnclosures < ActiveRecord::Migration[6.0]
  def change
    add_reference :enclosures, :location
  end
end
