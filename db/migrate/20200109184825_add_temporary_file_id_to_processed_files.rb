class AddTemporaryFileIdToProcessedFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :processed_files, :temporary_file_id, :integer
  end
end
