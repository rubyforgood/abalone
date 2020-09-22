class DropUntaggedAnimalAssessments < ActiveRecord::Migration[6.0]
  def up
    drop_table :untagged_animal_assessments
  end

  def down; end
end
