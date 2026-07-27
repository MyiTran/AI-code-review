module Github
  class AuthenticateUser
    def initialize(auth:)
      @auth = auth
    end

    def call
      user = find_or_initialize_user

      assign_identity(user)
      assign_github_data(user)
      prepare_new_user(user) if user.new_record?

      user.save!
      user
    end

    private

    attr_reader :auth

    def find_or_initialize_user
      User.find_by(
        provider: auth.provider,
        uid: auth.uid
      ) || find_existing_user_by_email || User.new
    end

    def find_existing_user_by_email
      return if github_email.blank?

      User.find_by(email: github_email)
    end

    def assign_identity(user)
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = github_email || fallback_email
      user.first_name = resolved_first_name
      user.last_name = resolved_last_name
    end

    def assign_github_data(user)
      user.github_username = auth.info.nickname
      user.avatar_url = auth.info.image
      user.github_access_token = auth.credentials.token
    end

    def prepare_new_user(user)
      user.password = Devise.friendly_token.first(32)
      user.skip_confirmation!
    end

    def github_email
      auth.info.email.to_s.downcase.presence
    end

    def fallback_email
      "github-#{auth.uid}@users.noreply.local"
    end

    def resolved_first_name
      parsed_name.first.presence ||
        auth.info.nickname.presence ||
        "GitHub"
    end

    def resolved_last_name
      parsed_name.drop(1).join(" ").presence ||
        "User"
    end

    def parsed_name
      @parsed_name ||= auth.info.name.to_s.strip.split
    end
  end
end