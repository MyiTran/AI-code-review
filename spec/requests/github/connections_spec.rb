require 'rails_helper'
require 'ostruct'

RSpec.describe 'GitHub connections', type: :request do
  let(:user) { create(:user) }
  let(:installation) { create(:github_installation, user: user) }
  let(:repository) { create(:repository, github_installation: installation, connected: false) }

  before do
    host! 'localhost'
    sign_in user
  end

  it 'reconnects repository when github still has access' do
    github_repo = OpenStruct.new(id: repository.github_id) # rubocop:disable Style/OpenStructUse

    allow(Github::ListRepositoriesService).to receive(:call).and_return([github_repo])

    post github_connection_path, params: { repository_id: repository.id }

    expect(repository.reload.connected).to be(true)
    expect(response).to redirect_to(repository_path(repository))
  end

  it 'redirects to github settings when github does not have access' do
    allow(Github::ListRepositoriesService).to receive(:call).and_return([])
    allow(Github::GetInstallationSettingsUrlService).to receive(:call).and_return('https://github.com/settings/installations/123')

    post github_connection_path, params: { repository_id: repository.id }

    expect(response).to redirect_to('https://github.com/settings/installations/123')
  end
end
