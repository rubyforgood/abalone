class CreateFileUploads < ActiveRecord::Migration[6.0]
  def change
    create_table :file_uploads do |t|
      t.references :user, foreign_key: true
      t.references :organization, foreign_key: true
      t.text :status, null: false
      t.timestamps
    end
  end
end
