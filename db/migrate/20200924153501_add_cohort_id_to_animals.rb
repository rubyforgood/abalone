class AddCohortIdToAnimals < ActiveRecord::Migration[6.0]
  def change
    add_reference :animals, :cohort, index: true
  end
end
