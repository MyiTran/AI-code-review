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
    name { 'Gemini Flash' }
    is_default { true }
  end
end
