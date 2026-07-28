module Github
  class AuthenticateUser
    def self.call(auth)
      new(auth).call
    end

    def initialize(auth)
      @auth = auth
    end

    def call
      user = find_or_initialize_user

      assign_github_attributes(user)
      prepare_new_user(user)

      user.save!
      user
    end

    private

    attr_reader :auth

    def find_or_initialize_user
      user = find_user_by_github_identity
      user ||= User.find_or_initialize_by(email: github_email)

      user
    end

    def find_user_by_github_identity
      User.find_by(provider: github_provider_value, uid: auth.uid.to_s)
    end

    def assign_github_attributes(user)
      user.assign_attributes(
        provider: :github,
        uid: auth.uid.to_s,
        email: github_email,
        first_name: first_name,
        last_name: last_name,
        github_username: auth.info.nickname,
        avatar_url: auth.info.image,
        github_access_token: auth.credentials.token
      )
    end

    def prepare_new_user(user)
      return unless user.new_record?

      user.password = Devise.friendly_token.first(32)
      user.confirmed_at = Time.current
    end

    def github_email
      auth.info.email.presence ||
        raise(ArgumentError, 'GitHub email is unavailable')
    end

    def github_provider_value
      User.provider.find_value(:github).value
    end

    def first_name
      github_name_parts.first.presence || auth.info.nickname
    end

    def last_name
      github_name_parts.second.to_s
    end

    def github_name_parts
      @github_name_parts ||= auth.info.name.to_s.strip.split(' ', 2)
    end
  end
end
