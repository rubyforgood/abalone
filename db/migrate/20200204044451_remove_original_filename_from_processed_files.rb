class RemoveOriginalFilenameFromProcessedFiles < ActiveRecord::Migration[5.2]
  def change
    remove_column :processed_files, :original_filename
  end
end
