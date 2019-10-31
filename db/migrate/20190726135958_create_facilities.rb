# frozen_string_literal: true

class CreateFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
