class AddNameToFamily < ActiveRecord::Migration[5.2]
  def change
    add_column :families, :name, :string
  end
end
