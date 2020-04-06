class AddDatesToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :operation_date, :datetime
    add_column :operations, :operation_type, :string
  end
end
