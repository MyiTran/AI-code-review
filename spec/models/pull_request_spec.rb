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
    subject(:pull_request) { build(:pull_request, repository: create(:repository)) }

    it { is_expected.to validate_presence_of(:github_id) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:state) }

    it do
      expect(pull_request)
        .to validate_uniqueness_of(:github_id)
        .scoped_to(:repository_id)
    end

    it do
      expect(pull_request)
        .to validate_uniqueness_of(:number)
        .scoped_to(:repository_id)
    end
  end
end
