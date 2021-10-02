class AddDefaultEntryPointToAnimals < ActiveRecord::Migration[6.1]
  def up
    change_column_default :animals, :entry_point, ''
  end

  def down
    change_column_default :animals, :entry_point, nil
  end
end
