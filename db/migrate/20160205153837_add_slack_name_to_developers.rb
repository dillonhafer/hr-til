class AddSlackNameToDevelopers < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      alter table developers add column slack_name varchar;
    SQL
  end

  def down
    execute <<-SQL
      alter table developers drop column slack_name;
    SQL
  end
end
