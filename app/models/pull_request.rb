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
class PullRequest < ApplicationRecord
  belongs_to :repository
  has_many :reviews, dependent: :destroy

  validates :github_id, presence: true, uniqueness: { scope: :repository_id }
  validates :number, presence: true, uniqueness: { scope: :repository_id }
  validates :title, :state, presence: true

  scope :by_user, ->(user) { joins(repository: :github_installation).where(github_installations: { user_id: user.id }) }
end
