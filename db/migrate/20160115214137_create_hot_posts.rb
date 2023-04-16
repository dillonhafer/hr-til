class CreateHotPosts < ActiveRecord::Migration[5.0]
  def change
    create_view :hot_posts
  end
end
