class AddTwitterHandleToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :twitter_handle, :string
  end
end
