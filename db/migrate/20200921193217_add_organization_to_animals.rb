class AddOrganizationToAnimals < ActiveRecord::Migration[6.0]
  def change
    add_reference :animals, :organization, foreign_key: true, after: :sex
  end
end
