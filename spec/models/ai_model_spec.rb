require 'rails_helper'

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
RSpec.describe AiModel, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:reviews).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    subject(:ai_model) { build(:ai_model) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_uniqueness_of(:slug) }
  end
end
