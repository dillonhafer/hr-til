class AddAdminToDeveloper < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :admin, :boolean
  end
end
