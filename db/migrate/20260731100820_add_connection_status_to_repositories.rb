class AddConnectionStatusToRepositories < ActiveRecord::Migration[8.1]
  def change
    add_column :repositories, :connected, :boolean, null: false, default: true
    add_column :repositories, :disconnected_at, :datetime
  end
end
