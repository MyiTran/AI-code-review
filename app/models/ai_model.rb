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
class AiModel < ApplicationRecord
  has_many :reviews, dependent: :restrict_with_error

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :provider, presence: true

  scope :default, -> { where(is_default: true) }
  scope :active, -> { where(active: true) }
  scope :non_premium, -> { where(is_premium: false) }
end
