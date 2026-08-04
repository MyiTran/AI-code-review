# == Schema Information
#
# Table name: repositories
#
#  id                     :uuid             not null, primary key
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
#  github_id              :bigint           not null
#  github_installation_id :uuid             not null
#
# Indexes
#
#  index_repositories_on_github_installation_id                (github_installation_id)
#  index_repositories_on_github_installation_id_and_github_id  (github_installation_id,github_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (github_installation_id => github_installations.id)
#
class Repository < ApplicationRecord
  belongs_to :github_installation
  has_many :pull_requests, dependent: :destroy

  validates :github_id, presence: true
  validates :name, presence: true
  validates :full_name, presence: true
  validates :github_id, uniqueness: { scope: :github_installation_id }

  delegate :user, to: :github_installation

  scope :search_by_keyword,
    ->(query) {
      where('name ILIKE :q OR full_name ILIKE :q', q: "%#{query}%") if query.present?
    }

  scope :by_language,
    ->(language) {
      where(language: language) if language.present?
    }

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

  def self.available_languages(repositories_scope)
    repositories_scope.where.not(language: [nil, '']).distinct.order(:language).pluck(:language)
  end
end
