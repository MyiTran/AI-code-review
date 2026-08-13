class CreateGithubWebhookDeliveries < ActiveRecord::Migration[8.1]
  def change
    create_table :github_webhook_deliveries, id: :uuid do |t|
      t.string :delivery_id, null: false
      t.string :event_name, null: false
      t.string :action
      t.string :status, null: false, default: 'received'
      t.jsonb :payload, null: false, default: {}
      t.datetime :processed_at

      t.timestamps
    end

    add_index :github_webhook_deliveries, :delivery_id, unique: true
  end
end
