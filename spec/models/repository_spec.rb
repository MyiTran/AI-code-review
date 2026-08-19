require 'rails_helper'

# == Schema Information
#
# Table name: repositories
#
#  id                     :uuid             not null, primary key
#  auto_review_enabled    :boolean          default(FALSE), not null
#  connected              :boolean          default(TRUE), not null
#  connected_at           :datetime         not null
#  default_branch         :string
#  description            :text
#  disconnected_at        :datetime
#  full_name              :string           not null
#  github_url             :string
#  language               :string
#  name                   :string           not null
#  visibility             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  ai_model_id            :uuid
#  github_id              :bigint           not null
#  github_installation_id :uuid             not null
#
# Indexes
#
#  index_repositories_on_ai_model_id                           (ai_model_id)
#  index_repositories_on_github_installation_id                (github_installation_id)
#  index_repositories_on_github_installation_id_and_github_id  (github_installation_id,github_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (ai_model_id => ai_models.id)
#  fk_rails_...  (github_installation_id => github_installations.id)
#
RSpec.describe Repository, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:github_installation) }
    it { is_expected.to belong_to(:ai_model).optional }
    it { is_expected.to have_many(:pull_requests).dependent(:destroy) }
  end

  describe 'validations' do
    subject(:repository) { build(:repository) }

    it { is_expected.to validate_presence_of(:github_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_uniqueness_of(:github_id).scoped_to(:github_installation_id) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:user).to(:github_installation) }
  end

  describe 'scopes' do
    let!(:repo_ruby) { create(:repository, name: 'ai-code-review', language: 'Ruby', connected: true) }
    let!(:repo_js) { create(:repository, name: 'blog-app', language: 'JavaScript', connected: false) }

    it 'filters by keyword' do
      expect(described_class.by_keyword('ai-code')).to include(repo_ruby)
      expect(described_class.by_keyword('ai-code')).not_to include(repo_js)
    end

    it 'filters by language' do
      expect(described_class.by_language('Ruby')).to include(repo_ruby)
      expect(described_class.by_language('Ruby')).not_to include(repo_js)
    end

    it 'filters by connection status' do
      expect(described_class.by_connection_status('connected')).to include(repo_ruby)
      expect(described_class.by_connection_status('disconnected')).to include(repo_js)
    end

    it 'returns unique available languages' do
      create(:repository, language: 'Ruby')
      create(:repository, language: nil)

      expect(described_class.available_languages(described_class.all)).to eq(['JavaScript', 'Ruby'])
    end
  end

  describe 'connection status methods' do
    it { expect(build(:repository, connected: true).connected?).to be(true) }
    it { expect(build(:repository, connected: false).disconnected?).to be(true) }
  end
end
