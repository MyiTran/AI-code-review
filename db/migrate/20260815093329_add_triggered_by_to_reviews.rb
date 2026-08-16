class AddTriggeredByToReviews < ActiveRecord::Migration[8.1]
  def change
    add_column :reviews, :triggered_by, :string
  end
end
