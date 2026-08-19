require 'rails_helper'

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
RSpec.describe GithubWebhookDelivery, type: :model do
  describe 'validations' do
    subject(:github_webhook_delivery) { build(:github_webhook_delivery) }

    it { is_expected.to validate_presence_of(:delivery_id) }
    it { is_expected.to validate_presence_of(:event_name) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_uniqueness_of(:delivery_id) }
  end

  describe 'enums' do
    it do
      expect(described_class.statuses).to eq(
        'received' => 'received',
        'processing' => 'processing',
        'processed' => 'processed',
        'failed' => 'failed'
      )
    end
  end

  describe '#processed!' do
    let(:delivery) { create(:github_webhook_delivery) }

    it 'marks the delivery as processed' do
      delivery.processed!

      expect(delivery).to be_processed
    end

    it 'sets processed_at' do
      delivery.processed!

      expect(delivery.processed_at).to be_present
    end
  end
end
