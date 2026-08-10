class AddGithubFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :github_username, :string
    add_column :users, :avatar_url, :string
    add_column :users, :github_access_token, :text
    add_index :users, :github_username
    add_index :users, %i[provider uid], unique: true, where: 'provider IS NOT NULL AND uid IS NOT NULL'
  end
end
