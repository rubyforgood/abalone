class CreateOperationBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :operation_batches do |t|
      t.string :name
      t.timestamps
    end

    change_table :operations do |operations_schema|
      operations_schema.references :operation_batch
    end
  end
end
