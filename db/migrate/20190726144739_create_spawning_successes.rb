class CreateSpawningSuccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :spawning_successes do |t|
      t.string :tag
      t.numeric :shl_number
      t.date :spawning_date
      t.date :date_attempted
      t.numeric :spawning_success
      t.numeric :nbr_of_eggs_spawned

      t.timestamps
    end
  end
end
