require 'rails_helper'

RSpec.describe Github::SyncPullRequestService do
  let!(:repository) { create(:repository, github_id: 123) }
  let!(:payload) do
    {
      'repository' => { 'id' => repository.github_id },
      'pull_request' => {
        'id' => 999,
        'number' => 10,
        'title' => 'Test PR',
        'user' => { 'login' => 'khoa-dev' },
        'state' => 'open',
        'head' => { 'ref' => 'feature/test', 'sha' => 'abc123' },
        'base' => { 'ref' => 'main' },
        'html_url' => 'https://github.com/test/repo/pull/10',
        'created_at' => Time.current.iso8601,
        'closed_at' => nil,
        'merged_at' => nil
      }
    }
  end

  it 'creates pull request from webhook payload' do
    delivery = create(:github_webhook_delivery, event_name: 'pull_request', action: 'opened', payload: payload)

    expect { described_class.call(delivery) }.to change(PullRequest, :count).by(1)
  end

  it 'does not process unsupported event' do
    delivery = create(:github_webhook_delivery, event_name: 'push', action: nil, payload: payload)

    expect(described_class.call(delivery)).to be_nil
  end

  it 'does not process unsupported action' do
    delivery = create(:github_webhook_delivery, event_name: 'pull_request', action: 'edited', payload: payload)

    expect(described_class.call(delivery)).to be_nil
  end
end
