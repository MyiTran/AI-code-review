require 'rails_helper'

# == Schema Information
#
# Table name: pull_requests
#
#  id              :uuid             not null, primary key
#  author          :string
#  closed_at       :datetime
#  github_url      :string
#  head_commit_sha :string
#  merged_at       :datetime
#  number          :integer          not null
#  opened_at       :datetime
#  source_branch   :string
#  state           :string           not null
#  target_branch   :string
#  title           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :bigint           not null
#  repository_id   :uuid             not null
#
# Indexes
#
#  index_pull_requests_on_repository_id                (repository_id)
#  index_pull_requests_on_repository_id_and_github_id  (repository_id,github_id) UNIQUE
#  index_pull_requests_on_repository_id_and_number     (repository_id,number) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#
RSpec.describe PullRequest, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:repository) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
  end

  describe 'validations' do
    subject(:pull_request) { build(:pull_request, repository: repository) }

    let(:user) { create(:user, email: "pull-request-#{SecureRandom.uuid}@example.com", uid: "github-uid-#{SecureRandom.uuid}", github_username: "github-user-#{SecureRandom.uuid}") }
    let(:installation) { create(:github_installation, user: user) }
    let(:repository) { create(:repository, github_installation: installation) }

    it { is_expected.to validate_presence_of(:github_id) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:state) }

    it 'validates github id uniqueness within repository' do
      existing = create(:pull_request, repository: repository)
      duplicate = build(:pull_request, repository: repository, github_id: existing.github_id)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:github_id]).to be_present
    end

    it 'validates number uniqueness within repository' do
      existing = create(:pull_request, repository: repository)
      duplicate = build(:pull_request, repository: repository, number: existing.number)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:number]).to be_present
    end
  end
end
