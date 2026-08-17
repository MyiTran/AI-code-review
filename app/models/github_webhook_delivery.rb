# == Schema Information
#
# Table name: github_webhook_deliveries
#
#  id           :uuid             not null, primary key
#  action       :string
#  event_name   :string           not null
#  payload      :jsonb            not null
#  processed_at :datetime
#  status       :string           default("received"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  delivery_id  :string           not null
#
# Indexes
#
#  index_github_webhook_deliveries_on_delivery_id  (delivery_id) UNIQUE
#
class GithubWebhookDelivery < ApplicationRecord
  validates :delivery_id, presence: true, uniqueness: true
  validates :event_name, :status, presence: true

  enum :status, { received: 'received', processing: 'processing', processed: 'processed', failed: 'failed' }, default: :received

  def processed!
    update!(status: :processed, processed_at: Time.current)
  end
end
