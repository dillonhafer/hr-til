class AddDefaultFalseToDeveloperAdminFlag < ActiveRecord::Migration[5.0]
  def change
    change_column_default :developers, :admin, false
  end
end
