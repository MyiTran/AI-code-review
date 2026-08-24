# == Schema Information
#
# Table name: roles
#
#  id            :uuid             not null, primary key
#  name          :string
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :uuid
#
# Indexes
#
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  index_roles_on_resource                                (resource_type,resource_id)
#
require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'constants' do
    it 'defines the correct role names' do
      expect(described_class::NAMES).to eq(%w[super_admin admin employee])
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:resource).optional }
    it { is_expected.to have_and_belong_to_many(:users) }
  end

  describe 'validations' do
    subject(:role) { build(:role) }

    it { is_expected.to validate_inclusion_of(:name).in_array(described_class::NAMES) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_inclusion_of(:resource_type).in_array(Rolify.resource_types).allow_nil }
  end
end
