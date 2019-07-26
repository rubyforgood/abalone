class CreatePedigrees < ActiveRecord::Migration[5.2]
  def change
    create_table :pedigrees do |t|

      t.timestamps
    end
  end
end
