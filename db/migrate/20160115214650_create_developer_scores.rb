class CreateDeveloperScores < ActiveRecord::Migration[5.0]
  def change
    create_view :developer_scores
  end
end
