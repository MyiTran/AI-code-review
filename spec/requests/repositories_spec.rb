require 'rails_helper'

RSpec.describe 'Repositories', type: :request do
  let(:user) { create(:user) }
  let(:installation) { create(:github_installation, user: user) }
  let(:repository) { create(:repository, github_installation: installation, connected: true) }

  before { host! 'localhost'; sign_in user }

  describe 'GET /repositories' do
    before { repository }

    it 'returns success' do
      get repositories_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /repositories/:id' do
    it 'returns success' do
      get repository_path(repository)
      expect(response).to have_http_status(:ok)
    end

    it 'does not allow user to view another user repository' do
      other_repo = create(:repository, github_installation: create(:github_installation, user: create(:user)))

      get repository_path(other_repo)
      expect([403, 404]).to include(response.status)
    end
  end

  describe 'PATCH /repositories/:id' do
    it 'updates auto review setting' do
      patch repository_path(repository), params: { repository: { auto_review_enabled: '1' } }

      expect(response).to have_http_status(:see_other)
      expect(repository.reload.auto_review_enabled).to be(true)
    end

    it 'disconnects repository' do
      patch repository_path(repository), params: { repository: { connected: '0' } }

      expect(response).to have_http_status(:see_other)
      expect(repository.reload.connected).to be(false)
      expect(repository.disconnected_at).to be_present
    end
  end
end
