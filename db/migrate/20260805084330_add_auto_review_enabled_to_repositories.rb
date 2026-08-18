class AddAutoReviewEnabledToRepositories < ActiveRecord::Migration[8.1]
  def change
    add_column :repositories, :auto_review_enabled, :boolean, null: false, default: false
  end
end
