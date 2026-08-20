require 'rails_helper'

RSpec.describe 'GitHub webhook deliveries', type: :request do
  let(:payload) { { action: 'opened' }.to_json }
  let(:headers) do
    {
      'X-Hub-Signature-256' => 'sha256=valid',
      'X-GitHub-Delivery' => 'delivery-123',
      'X-GitHub-Event' => 'pull_request',
      'CONTENT_TYPE' => 'application/json'
    }
  end

  before do
    allow(Github::VerifyWebhookSignatureService).to receive(:call).and_return(true)
    allow(Github::ProcessWebhookJob).to receive(:perform_async)
  end

  it 'creates webhook delivery' do
    expect do
      post github_deliveries_path, params: payload, headers: headers
    end.to change(GithubWebhookDelivery, :count).by(1)
  end

  it 'enqueues process webhook job' do
    post github_deliveries_path, params: payload, headers: headers

    expect(Github::ProcessWebhookJob).to have_received(:perform_async)
  end

  it 'returns accepted' do
    post github_deliveries_path, params: payload, headers: headers

    expect(response).to have_http_status(:accepted)
  end

  it 'returns unauthorized for invalid signature' do
    allow(Github::VerifyWebhookSignatureService).to receive(:call).and_return(false)

    post github_deliveries_path, params: payload, headers: headers

    expect(response).to have_http_status(:unauthorized)
  end

  it 'does not create duplicate delivery' do
    create(:github_webhook_delivery, delivery_id: 'delivery-123')

    expect do
      post github_deliveries_path, params: payload, headers: headers
    end.not_to change(GithubWebhookDelivery, :count)
  end
end
