class AddTweetedToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :tweeted, :boolean, default: false
  end
end
