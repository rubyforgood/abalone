class CreateExitTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :exit_types do |t|
      t.string :name
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
