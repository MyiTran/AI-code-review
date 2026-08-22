require 'rails_helper'

RSpec.describe 'Pull requests', type: :request do
  let(:user) { create(:user) }
  let(:installation) { create(:github_installation, user: user) }
  let(:repository) { create(:repository, github_installation: installation) }
  let(:pull_request) { create(:pull_request, repository: repository) }

  before { host! 'localhost'; sign_in user }

  describe 'GET /pull_requests/:id' do
    it 'returns success' do
      get pull_request_path(pull_request)
      expect(response).to have_http_status(:ok)
    end

    it 'does not allow user to view another user pull request' do
      other_repo = create(:repository, github_installation: create(:github_installation, user: create(:user)))
      other_pull_request = create(:pull_request, repository: other_repo)

      get pull_request_path(other_pull_request)
      expect(response).to have_http_status(:not_found)
    end
  end
end
