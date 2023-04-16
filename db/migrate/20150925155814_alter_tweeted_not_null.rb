class AlterTweetedNotNull < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      update posts set tweeted = false;
      alter table posts alter column tweeted set not null;
    SQL
  end

  def down
    execute <<-SQL
      alter table posts alter column tweeted drop not null;
    SQL
  end
end
