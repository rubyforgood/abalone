class CreateAnimalsShlNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :animals_shl_numbers do |t|
      t.references :animal
      t.references :shl_number

      t.timestamps
    end
  end
end
