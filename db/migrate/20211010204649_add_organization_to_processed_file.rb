class AddOrganizationToProcessedFile < ActiveRecord::Migration[6.1]
  def change
    add_reference :processed_files, :organization, foreign_key: true
  end
end
