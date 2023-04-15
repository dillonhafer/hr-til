class NullifyEmptySlackNames < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      update developers set slack_name = null where slack_name = '';
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
