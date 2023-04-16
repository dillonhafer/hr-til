class AddConstraintsToTags < ActiveRecord::Migration[5.0]
  def change
    change_column_null :tags, :created_at, false
    change_column_null :tags, :updated_at, false
  end
end
