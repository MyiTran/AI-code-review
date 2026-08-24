# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  avatar_url             :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  github_access_token    :text
#  github_username        :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  plan                   :string           default("free"), not null
#  provider               :integer
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  uid                    :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_github_username       (github_username)
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE WHERE ((provider IS NOT NULL) AND (uid IS NOT NULL))
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |number| "user#{number}@gmail.com" }
    password { 'Password123@' }
    password_confirmation { password }
    confirmed_at { Time.current }

    provider { :github }
    sequence(:uid) { |number| "github-uid-#{number}" }
    sequence(:github_username) { |number| "github-user-#{number}" }
    github_access_token { 'github-access-token' }

    after(:create) { |user| user.add_role(:employee) }

    trait :admin do
      after(:create) do |user|
        user.remove_role(:employee)
        user.add_role(:admin)
      end
    end

    trait :super_admin do
      after(:create) do |user|
        user.remove_role(:employee)
        user.add_role(:super_admin)
      end
    end
  end
end
