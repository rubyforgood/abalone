class RenameOperationsOperationTypeToPreventRailsNamingCollisions < ActiveRecord::Migration[5.2]
  def change
    # `type` is a reserved word in Rails, that can cause
    # surprising behavior when using Single Table Iheritance
    # or Polymorphic assocations.

    # This is because Rails infers that fields named with `type`
    # indicate the class that should be used when deserializing
    # the data from the database into a Rails model.
    rename_column :operations, :operation_type, :action
  end
end
