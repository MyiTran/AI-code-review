# == Schema Information
#
# Table name: ai_models
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(TRUE), not null
#  is_default :boolean          default(FALSE), not null
#  is_premium :boolean          default(FALSE), not null
#  name       :string           not null
#  provider   :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ai_models_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :ai_model do
    sequence(:name) { |number| "Gemini Model #{number}" }
    sequence(:slug) { |number| "gemini-model-#{number}" }

    provider { 'google' }
    active { true }
    is_default { false }
    is_premium { false }

    trait :default do
      is_default { true }
    end

    trait :premium do
      is_premium { true }
    end

    trait :inactive do
      active { false }
    end
  end
end
