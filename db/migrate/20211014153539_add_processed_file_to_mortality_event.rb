class AddProcessedFileToMortalityEvent < ActiveRecord::Migration[6.1]
  def change
    add_reference :mortality_events, :processed_file, foreign_key: true
  end
end
