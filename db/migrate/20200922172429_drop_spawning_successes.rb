class DropSpawningSuccesses < ActiveRecord::Migration[6.0]
  def up
    drop_table :spawning_successes
  end

  def down; end
end
