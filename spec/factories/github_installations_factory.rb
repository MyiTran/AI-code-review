# == Schema Information
#
# Table name: github_installations
#
#  id                   :uuid             not null, primary key
#  account_login        :string           not null
#  account_type         :string           not null
#  repository_selection :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :bigint           not null
#  installation_id      :bigint           not null
#  user_id              :uuid             not null
#
# Indexes
#
#  index_github_installations_on_installation_id  (installation_id) UNIQUE
#  index_github_installations_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :github_installation do
    association :user

    sequence(:installation_id) { |number| 1000 + number }
    sequence(:account_id) { |number| 2000 + number }
    account_login { user.github_username }
    account_type { 'User' }
    repository_selection { 'selected' }

    trait :organization do
      account_type { 'Organization' }
      account_login { 'test-org' }
    end
  end
end
