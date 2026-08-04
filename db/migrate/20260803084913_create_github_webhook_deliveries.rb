class CreatePullRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :pull_requests, id: :uuid do |t|
      t.references :repository, null: false, foreign_key: true, type: :uuid
      t.bigint :github_id, null: false
      t.integer :number, null: false
      t.string :title, null: false
      t.string :author
      t.string :state, null: false
      t.string :source_branch
      t.string :target_branch
      t.string :head_commit_sha
      t.string :github_url
      t.datetime :opened_at
      t.datetime :closed_at
      t.datetime :merged_at

      t.timestamps
    end

    add_index :pull_requests, [:repository_id, :github_id], unique: true
    add_index :pull_requests, [:repository_id, :number], unique: true
  end
end
