class AddBaseCommitShaToReviews < ActiveRecord::Migration[8.1]
  def change
    add_column :reviews, :base_commit_sha, :string
  end
end
