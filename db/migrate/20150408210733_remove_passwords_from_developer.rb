class RemovePasswordsFromDeveloper < ActiveRecord::Migration[5.0]
  def up
    remove_column :developers, :password_digest
    remove_column :developers, :password_reset_token
  end

  def down
    add_column :developers, :password_digest, :string, null: false
    add_column :developers, :password_reset_token, :string, limit: 60, null: false
  end
end
