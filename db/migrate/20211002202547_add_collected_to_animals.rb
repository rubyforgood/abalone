class AddCollectedToAnimals < ActiveRecord::Migration[6.1]
  def up
    add_column :animals, :collected, :boolean, default: false
  end

  def down
    remove_column :animals, :collected, :boolean
  end
end
