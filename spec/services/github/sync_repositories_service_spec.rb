require 'rails_helper'
require 'ostruct'

RSpec.describe Github::SyncRepositoriesService do
  let!(:installation) { create(:github_installation) }
  let!(:github_repo) do
    OpenStruct.new( # rubocop:disable Style/OpenStructUse
      id: 111,
      name: 'AI-code-review',
      full_name: 'MyiTran/AI-code-review',
      description: 'Test repo',
      language: 'Ruby',
      visibility: 'private',
      default_branch: 'main',
      html_url: 'https://github.com/MyiTran/AI-code-review'
    )
  end

  before { allow(Github::ListRepositoriesService).to receive(:call).and_return([github_repo]) }

  it 'creates repositories from github response' do
    expect { described_class.call(installation) }.to change(Repository, :count).by(1)
  end

  it 'updates existing repository' do
    create(:repository, github_installation: installation, github_id: 111, name: 'old-name')
    described_class.call(installation)

    expect(installation.repositories.find_by(github_id: 111).name).to eq('AI-code-review')
  end

  it 'marks missing repositories as disconnected' do
    old_repository = create(:repository, github_installation: installation, github_id: 999, connected: true)
    described_class.call(installation)

    expect(old_repository.reload.connected).to be(false)
    expect(old_repository.disconnected_at).to be_present
  end
end
