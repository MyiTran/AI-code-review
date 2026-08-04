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
FactoryBot.define do
  factory :github_webhook_delivery do
  end
end
