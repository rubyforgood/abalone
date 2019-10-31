# frozen_string_literal: true

class CreateProcessedFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :processed_files do |t|
      t.string :filename
      t.string :original_filename
      t.string :category
      t.string :status
      t.jsonb :job_stats, null: false, default: '{}'
      t.text :job_errors

      t.timestamps
    end
  end
end
