class AddEditorToDeveloper < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :editor, :string, default: "Text Field"
  end
end
