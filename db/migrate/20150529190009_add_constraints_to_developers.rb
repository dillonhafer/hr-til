class AddConstraintsToDevelopers < ActiveRecord::Migration[5.0]
  def change
    change_column_null :developers, :created_at, false
    change_column_null :developers, :updated_at, false
  end
end
