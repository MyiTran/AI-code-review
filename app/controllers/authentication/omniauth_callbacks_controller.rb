module Authentication
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      user = Github::AuthenticateUser.call(omniauth_auth)

      sign_in(user)

      redirect_to(dashboard_path, notice: 'Signed in successfully with GitHub.')
    rescue ActiveRecord::RecordInvalid, ArgumentError, KeyError => e
      Rails.logger.error(
        'GitHub authentication failed: ' \
        "#{e.class} - #{e.message}"
      )

      redirect_to(new_user_session_path, alert: 'Could not sign in with GitHub.')
    end

    def failure
      redirect_to(new_user_session_path, alert: 'GitHub authentication failed or was cancelled.')
    end

    private

    def omniauth_auth
      request.env.fetch('omniauth.auth')
    end
  end
end
