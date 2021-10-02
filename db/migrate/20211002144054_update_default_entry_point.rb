class UpdateDefaultEntryPoint < ActiveRecord::Migration[6.1]
  def change
    change_column_default :animals, :entry_point, ''
  end
end
