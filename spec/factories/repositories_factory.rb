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
    github_installation { nil }
    github_id { '' }
    name { 'MyString' }
    full_name { 'MyString' }
    description { 'MyText' }
    language { 'MyString' }
    visibility { 'MyString' }
    default_branch { 'MyString' }
    github_url { 'MyString' }
    connected_at { '2026-07-30 14:17:30' }
  end
end
