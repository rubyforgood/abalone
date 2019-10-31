# frozen_string_literal: true

class RenameSpawingSuccessesShlNumberToShlCaseNumber < ActiveRecord::Migration[5.2]
  def change
    rename_column :spawning_successes, :shl_number, :shl_case_number
  end
end
