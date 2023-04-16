class CreateTag < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end
