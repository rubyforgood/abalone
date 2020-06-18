class AddProcessedFileToMeasurements < ActiveRecord::Migration[5.2]
  def change
    add_reference :measurements, :processed_file, foreign_key: true
  end
end
