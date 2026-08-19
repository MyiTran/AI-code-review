class AddGithubCommentToReviews < ActiveRecord::Migration[8.1]
  def change
    add_column :reviews, :github_comment_id, :bigint
    add_column :reviews, :commented_at, :datetime
  end
end
