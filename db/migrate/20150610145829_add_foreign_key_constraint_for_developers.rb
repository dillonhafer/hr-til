class AddForeignKeyConstraintForDevelopers < ActiveRecord::Migration[5.0]
  def change
    change_table :posts do |t|
      add_foreign_key :posts, :developers
    end
  end
end
