class CreateTemporaryFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :temporary_files do |t|
      t.text :contents

      t.timestamps
    end
  end
end
