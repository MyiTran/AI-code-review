# == Schema Information
#
# Table name: reviews
#
#  id                 :uuid             not null, primary key
#  base_commit_sha    :string
#  commented_at       :datetime
#  commit_sha         :string           not null
#  error_message      :text
#  issues_found_count :integer          default(0), not null
#  latency_ms         :integer
#  review_content     :text
#  reviewed_at        :datetime
#  status             :string           default("processing"), not null
#  summary            :text
#  tokens_used        :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  ai_model_id        :uuid             not null
#  github_comment_id  :bigint
#  pull_request_id    :uuid             not null
#
# Indexes
#
#  idx_on_pull_request_id_commit_sha_ai_model_id_b6a69c7c0b  (pull_request_id,commit_sha,ai_model_id) UNIQUE
#  index_reviews_on_ai_model_id                              (ai_model_id)
#  index_reviews_on_pull_request_id                          (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (ai_model_id => ai_models.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#
class Review < ApplicationRecord
  belongs_to :pull_request
  belongs_to :ai_model

  enum :status, { processing: 'processing', completed: 'completed', failed: 'failed' }

  validates :commit_sha, presence: true
  validates :status, presence: true

  scope :by_user, ->(user) { joins(pull_request: { repository: :github_installation }).where(github_installations: { user_id: user.id }) }
  scope :by_repository, ->(repo_id) { where(pull_requests: { repository_id: repo_id }) if repo_id.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_ai_model, ->(model_id) { where(ai_model_id: model_id) if model_id.present? }
  scope :search_by_query,
    ->(query_string) {
      return all if query_string.blank?

      query = "%#{query_string.strip}%"
      where('pull_requests.title ILIKE :query OR repositories.name ILIKE :query OR CAST(pull_requests.number AS TEXT) ILIKE :query', query: query)
    }

  def previous_review
    pull_request.reviews
      .where(ai_model: ai_model)
      .where(created_at: ...created_at)
      .order(created_at: :desc)
      .first
  end
end
