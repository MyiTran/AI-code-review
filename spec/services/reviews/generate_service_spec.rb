require 'rails_helper'

RSpec.describe Reviews::GenerateService do
  let!(:review) { create(:review) }
  let!(:files) do
    [
      {
        filename: 'app/models/user.rb',
        status: 'modified',
        additions: 1,
        deletions: 1,
        patch: '+ test'
      }
    ]
  end
  let!(:ai_response) do
    {
      content: <<~CONTENT.strip,
        ## Summary
        Found issues.

        ## Review
        ### Issue 1

        - File: app/models/user.rb
        - Problem: bug
        - Suggestion: fix it
      CONTENT
      tokens_used: 200
    }
  end

  before do
    allow(Github::FetchPullRequestDiffService).to receive(:call).and_return(files)
    allow(Ai::Providers::GeminiService).to receive(:call).and_return(ai_response)
  end

  it 'marks review as completed' do
    described_class.call(review)

    expect(review.reload.status).to eq('completed')
  end

  it 'saves review result' do
    described_class.call(review)

    expect(review.reload.summary).to eq('Found issues.')
    expect(review.review_content).to include('Issue 1')
    expect(review.tokens_used).to eq(200)
  end

  it 'counts issues' do
    described_class.call(review)

    expect(review.reload.issues_found_count).to eq(1)
  end
end
