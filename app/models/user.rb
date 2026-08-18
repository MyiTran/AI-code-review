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
class User < ApplicationRecord
  rolify

  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :confirmable,
    :trackable,
    :omniauthable,
    omniauth_providers: [:github]

  # enums
  enumerize :provider, in: { email: 0, github: 1 }, default: :email, scope: true
  enumerize :plan, in: { free: 'free', pro: 'pro' }, default: :free, scope: true

  # encrypts
  encrypts :github_access_token

  # associations
  has_one_attached :avatar
  has_many :github_installations, dependent: :destroy
  has_many :repositories, through: :github_installations

  # validations
  validates :password, password: true
  validates :avatar, content_type: Constants::IMAGE_CONTENT_TYPES, size: { less_than: Constants::IMAGE_MAX_SIZE }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  # instance methods
  def display_name
    full_name.presence || github_username.presence || email.split('@').first
  end

  def initials
    (display_name.presence || email).split.filter_map(&:first).join.upcase
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def super_admin?
    has_role?(:super_admin)
  end

  def admin?
    has_role?(:admin)
  end

  def employee?
    has_role?(:employee)
  end

  def pro?
    plan == 'pro'
  end

  # scopes
  scope :search, ->(keyword) { keyword.blank? ? all : where('first_name ILIKE :kw OR last_name ILIKE :kw OR email ILIKE :kw OR github_username ILIKE :kw', kw: "%#{keyword}%") }

  # class methods
  def self.ransackable_attributes(_auth_object = nil)
    %w[first_name last_name email]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
