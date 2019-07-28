class AddMeasurementEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :tagged_animal_assessments, :measurement_event, :integer
    add_column :untagged_animal_assessments, :measurement_event, :integer
  end
end
