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
FactoryBot.define do
  factory :repository do
    github_installation

    sequence(:github_id) { |number| 4_200_000_000 + number }
    name { 'AI-code-review' }
    full_name { "MyiTran/#{name}" }
    description { 'Test repository' }
    language { 'Ruby' }
    visibility { 'private' }
    default_branch { 'main' }
    github_url { "https://github.com/#{full_name}" }
    connected { true }
    connected_at { Time.current }
    auto_review_enabled { false }

    trait :disconnected do
      connected { false }
      disconnected_at { Time.current }
    end
  end
end
