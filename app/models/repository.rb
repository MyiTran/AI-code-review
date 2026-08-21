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
class Repository < ApplicationRecord
  CACHE_EXPIRES_IN = 5.minutes

  belongs_to :github_installation
  belongs_to :ai_model, optional: true
  has_many :pull_requests, dependent: :destroy

  after_commit :clear_repositories_count_cache, on: :create

  validates :github_id, :name, :full_name, presence: true
  validates :github_id, uniqueness: { scope: :github_installation_id }

  delegate :user, to: :github_installation

  scope :by_keyword, ->(query) { where('name ILIKE :q OR full_name ILIKE :q', q: "%#{query}%") if query.present? }
  scope :by_language, ->(language) { where(language: language) if language.present? }
  scope :by_ai_model,
    ->(ai_model_id) do
      next all if ai_model_id.blank?

      model = AiModel.find_by(id: ai_model_id)
      next none unless model

      model.is_default? ? where(ai_model_id: [ai_model_id, nil]) : where(ai_model_id: ai_model_id)
    end

  scope :by_connection_status,
    ->(status) {
      if status.present?
        case status
        when 'connected' then where(connected: true)
        when 'disconnected' then where(connected: false)
        end
      end
    }

  def connected?
    connected
  end

  def disconnected?
    !connected
  end

  def latest_review
    Review.joins(:pull_request)
      .where(pull_requests: { repository_id: id })
      .order(reviewed_at: :desc)
      .first
  end

  def self.available_languages(repositories_scope)
    repositories_scope.where.not(language: [nil, '']).distinct.order(:language).pluck(:language)
  end

  def self.cached_count(user)
    Rails.cache.fetch(count_cache_key(user), expires_in: CACHE_EXPIRES_IN) do
      user.repositories.count
    end
  end

  def self.clear_count_cache(user)
    Rails.cache.delete(count_cache_key(user))
  end

  def self.count_cache_key(user)
    "users/#{user.id}/repositories_count"
  end

  private

  def clear_repositories_count_cache
    Repository.clear_count_cache(user)
  end
end
