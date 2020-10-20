class CreateMortalityEventsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :mortality_events do |t|
      t.datetime :mortality_date
      t.references :animal
      t.references :cohort
      t.integer :mortality_count

      t.timestamps
    end
  end
end
