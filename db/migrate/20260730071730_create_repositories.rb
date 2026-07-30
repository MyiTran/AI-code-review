class CreateRepositories < ActiveRecord::Migration[8.1]
  def change
    create_table :repositories, id: :uuid do |t|
      t.references :github_installation, null: false, foreign_key: true, type: :uuid
      t.bigint :github_id, null: false
      t.string :name, null: false
      t.string :full_name, null: false
      t.text :description
      t.string :language
      t.string :visibility
      t.string :default_branch
      t.string :github_url
      t.datetime :connected_at, null: false

      t.timestamps
    end

    add_index :repositories, [:github_installation_id, :github_id], unique: true
  end
end
