class CreateTanks < ActiveRecord::Migration[5.2]
  def change
    create_table :tanks do |t|
      t.references :facility, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
