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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_one_attached(:avatar) }
    it { is_expected.to have_many(:github_installations).dependent(:destroy) }
    it { is_expected.to have_many(:repositories).through(:github_installations) }
  end

  describe 'validations' do
    subject(:user) { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('wrong-email').for(:email) }

    it 'validates avatar content type' do
      user.avatar.attach(io: Rails.root.join('spec/fixtures/files/image.png').open, filename: 'avatar.png', content_type: 'image/png')
      expect(user).to be_valid

      user.avatar.attach(io: Rails.root.join('spec/fixtures/files/text.txt').open, filename: 'avatar.txt', content_type: 'text/plain')
      expect(user).not_to be_valid
    end

    it 'validates avatar size' do
      user.avatar.attach(io: Rails.root.join('spec/fixtures/files/image.png').open, filename: 'large.jpg', content_type: 'image/jpeg')
      allow(user.avatar.blob).to receive(:byte_size).and_return(11.megabytes)
      expect(user).not_to be_valid
    end
  end

  describe 'devise modules' do
    it do
      expect(described_class.devise_modules).to include(
        :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable,
        :validatable,
        :confirmable,
        :trackable,
        :omniauthable
      )
    end
  end

  describe '#display_name' do
    it 'returns full name or github username' do
      u1 = build(:user, first_name: 'Khoa', last_name: 'Nguyen', github_username: 'khoa-dev')
      u2 = build(:user, first_name: nil, last_name: nil, github_username: 'khoa-dev')

      expect(u1.display_name).to eq('Khoa Nguyen')
      expect(u2.display_name).to eq('khoa-dev')
    end
  end

  describe '#initials' do
    it { expect(build(:user, first_name: 'Khoa', last_name: 'Nguyen').initials).to eq('KN') }
  end

  describe '#full_name' do
    it { expect(build(:user, first_name: 'Khoa', last_name: 'Nguyen').full_name).to eq('Khoa Nguyen') }
  end

  describe 'roles' do
    it { expect(create(:user, :admin).admin?).to be(true) }
    it { expect(create(:user).admin?).to be(false) }
    it { expect(create(:user).employee?).to be(true) }
    it { expect(create(:user).super_admin?).to be(false) }
  end
end
