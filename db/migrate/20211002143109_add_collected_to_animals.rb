class AddCollectedToAnimals < ActiveRecord::Migration[6.1]
  def change
    add_column :animals, :collected, :boolean, null: false, default: true
  end
end
