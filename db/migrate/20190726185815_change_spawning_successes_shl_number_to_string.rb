# frozen_string_literal: true

class ChangeSpawningSuccessesShlNumberToString < ActiveRecord::Migration[5.2]
  def change
    change_column :spawning_successes, :shl_number, :string
  end
end
