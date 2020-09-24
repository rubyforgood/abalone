class CreateShlNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :shl_numbers do |t|
      t.string :code

      t.timestamps
    end
  end
end
