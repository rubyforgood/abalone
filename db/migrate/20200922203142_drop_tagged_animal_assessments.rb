class DropTaggedAnimalAssessments < ActiveRecord::Migration[6.0]
  def up
    drop_table :tagged_animal_assessments
  end

  def down; end
end
