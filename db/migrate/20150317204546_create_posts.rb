class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.belongs_to :developer, index: true, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
