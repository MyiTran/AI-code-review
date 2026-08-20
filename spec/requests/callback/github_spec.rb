require 'rails_helper'
require 'ostruct'

RSpec.describe 'GitHub callback', type: :request do
  let(:user) { create(:user) }
  let(:github_installation) { OpenStruct.new(id: 123) } # rubocop:disable Style/OpenStructUse
  let(:installation) { create(:github_installation, user: user, installation_id: 123) }

  before do
    host! 'localhost'
    sign_in user

    allow(Github::FetchInstallationService).to receive(:call).and_return(github_installation)
    allow(Github::SaveInstallationService).to receive(:call).and_return(installation)
    allow(Github::SyncRepositoriesService).to receive(:call)
  end

  it 'fetches installation from github' do
    get callback_github_path, params: { installation_id: 123 }

    expect(Github::FetchInstallationService).to have_received(:call).with('123')
  end

  it 'syncs repositories' do
    get callback_github_path, params: { installation_id: 123 }

    expect(Github::SyncRepositoriesService).to have_received(:call).with(installation)
  end

  it 'redirects to repositories page' do
    get callback_github_path, params: { installation_id: 123 }

    expect(response).to redirect_to(repositories_path)
  end
end
