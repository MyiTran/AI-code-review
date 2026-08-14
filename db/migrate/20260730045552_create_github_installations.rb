class CreateGithubInstallations < ActiveRecord::Migration[8.1]
  def change
    create_table :github_installations, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.bigint :installation_id, null: false
      t.string :account_login, null: false
      t.bigint :account_id, null: false
      t.string :account_type, null: false
      t.string :repository_selection, null: false

      t.timestamps
    end

    add_index :github_installations, :installation_id, unique: true
  end
end
