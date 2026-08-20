require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let(:user) { create(:user) }
  let(:installation) { create(:github_installation, user: user) }
  let(:repository) { create(:repository, github_installation: installation) }
  let(:pull_request) { create(:pull_request, repository: repository) }
  let(:ai_model) { create(:ai_model) }
  let(:review) { create(:review, pull_request: pull_request, ai_model: ai_model) }

  before do
    host! 'localhost'
    sign_in user
  end

  describe 'GET /reviews' do
    before do
      review
    end

    it 'returns success' do
      get reviews_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /reviews/:id' do
    before do
      allow(Github::FetchPullRequestDiffService).to receive(:call).and_return([])
    end

    it 'returns success' do
      get review_path(review)

      expect(response).to have_http_status(:ok)
    end

    it 'fetches changed files' do
      get review_path(review)

      expect(Github::FetchPullRequestDiffService).to have_received(:call)
    end

    it 'does not allow user to view another user review' do
      other_user = create(:user)
      other_installation = create(:github_installation, user: other_user)
      other_repository = create(:repository, github_installation: other_installation)
      other_pull_request = create(:pull_request, repository: other_repository)
      other_review = create(:review, pull_request: other_pull_request, ai_model: ai_model)

      get review_path(other_review)

      expect(response).to have_http_status(:not_found)
    end
  end
end
