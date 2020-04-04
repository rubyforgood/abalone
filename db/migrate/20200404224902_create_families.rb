class CreateFamilies < ActiveRecord::Migration[5.2]
  def change
    create_table :families do |t|
      t.references :female, foreign_key: true
      t.references :male, foreign_key: true

      t.timestamps
    end
  end
end
