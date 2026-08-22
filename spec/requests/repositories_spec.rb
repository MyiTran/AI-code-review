require 'rails_helper'

RSpec.describe 'Repositories', type: :request do
  let(:user) { create(:user) }
  let(:installation) { create(:github_installation, user: user) }
  let(:repository) do
    create(
      :repository,
      github_installation: installation,
      name: 'current-user-repo',
      full_name: 'current-user/current-user-repo',
      connected: true
    )
  end

  let(:other_user) { create(:user) }
  let(:other_installation) { create(:github_installation, user: other_user) }
  let(:other_repository) do
    create(
      :repository,
      github_installation: other_installation,
      name: 'other-user-repo',
      full_name: 'other-user/other-user-repo'
    )
  end

  before do
    host! 'localhost'
    sign_in user
  end

  describe 'GET /repositories' do
    before do
      repository
      other_repository
    end

    it 'returns only current user repositories' do
      get repositories_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(repository_path(repository))
      expect(response.body).not_to include(repository_path(other_repository))
    end
  end

  describe 'GET /repositories/:id' do
    it 'returns success' do
      get repository_path(repository)

      expect(response).to have_http_status(:ok)
    end

    it 'does not allow user to view another user repository' do
      get repository_path(other_repository)

      expect([403, 404]).to include(response.status)
    end
  end

  describe 'PATCH /repositories/:id' do
    it 'updates auto review setting' do
      patch repository_path(repository),
        params: { repository: { auto_review_enabled: '1' } }

      expect(response).to have_http_status(:see_other)
      expect(repository.reload.auto_review_enabled).to be(true)
    end

    it 'disconnects repository' do
      patch repository_path(repository),
        params: { repository: { connected: '0' } }

      expect(response).to have_http_status(:see_other)
      expect(repository.reload.connected).to be(false)
      expect(repository.disconnected_at).to be_present
    end
  end
end
