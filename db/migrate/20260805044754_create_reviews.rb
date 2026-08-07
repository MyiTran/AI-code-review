class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews, id: :uuid do |t|
      t.references :pull_request, null: false, foreign_key: true, type: :uuid
      t.references :ai_model, null: false, foreign_key: true, type: :uuid
      t.string :commit_sha, null: false
      t.string :status, null: false, default: 'processing'
      t.text :summary
      t.text :review_content
      t.integer :issues_found_count, null: false, default: 0
      t.integer :tokens_used
      t.integer :latency_ms
      t.datetime :reviewed_at
      t.text :error_message

      t.timestamps
    end

    add_index :reviews, [:pull_request_id, :commit_sha, :ai_model_id], unique: true
  end
end
