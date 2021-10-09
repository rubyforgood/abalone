class AddExitTypeToMortalityEvent < ActiveRecord::Migration[6.1]
  def change
    add_reference :mortality_events, :exit_type, foreign_key: true
  end
end
