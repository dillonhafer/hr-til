class ConstrainLikesToGreaterThanZero < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      alter table posts add constraint likes check (likes >= 0);
    SQL
  end

  def down
    execute <<-SQL
      alter table posts drop constraint likes;
    SQL
  end
end
