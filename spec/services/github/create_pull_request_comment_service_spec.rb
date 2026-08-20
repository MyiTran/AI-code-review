require 'rails_helper'
require 'ostruct'

RSpec.describe Github::CreatePullRequestCommentService do
  let(:review) { create(:review, :completed) }
  let(:client) { instance_double(Octokit::Client) }
  let(:comment) { OpenStruct.new(id: 12345) } # rubocop:disable Style/OpenStructUse

  before do
    allow(Github::GenerateInstallationTokenService).to receive(:call).and_return('token')
    allow(Octokit::Client).to receive(:new).and_return(client)
    allow(client).to receive(:add_comment).and_return(comment)
  end

  it 'creates github comment' do
    described_class.call(review)

    expect(client).to have_received(:add_comment)
  end

  it 'saves github comment id' do
    described_class.call(review)

    expect(review.reload.github_comment_id).to eq(12345)
    expect(review.commented_at).to be_present
  end

  it 'does not create comment again when review already has comment id' do
    review = create(:review, :completed, :commented)

    described_class.call(review)

    expect(client).not_to have_received(:add_comment)
  end
end
