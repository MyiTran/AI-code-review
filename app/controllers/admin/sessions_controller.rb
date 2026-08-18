module Admin
  class SessionsController < Devise::SessionsController
    layout 'devise'

    def create
      super do |user|
        unless user.admin? || user.super_admin?
          sign_out(user)
          return redirect_to admin_login_path, alert: 'You are not authorized to access admin!'
        end
      end
    end

    protected

    def after_sign_in_path_for(_resource)
      admin_root_path
    end

    def after_sign_out_path_for(_resource_or_scope)
      admin_login_path
    end
  end
end
