module Admin
  class AdminsController < BaseController
    before_action :require_super_admin!

    def index
      authorize User, policy_class: Admin::AdminPolicy

      admins = policy_scope(User, policy_scope_class: Admin::AdminPolicy::Scope).search(params[:q])
      @pagy, @admins = pagy(admins, limit: 10)
    end

    def new
      @admin = User.new
    end

    def edit
      @admin = admin
    end

    def create
      @admin = User.new(admin_params)
      @admin.provider = :email
      @admin.confirmed_at = Time.current

      if @admin.save
        @admin.add_role(params[:role])
        redirect_to admin_admins_path, notice: 'Admin created!'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      @admin = admin

      if @admin.update(admin_params)
        @admin.roles = []
        @admin.add_role(params[:role])
        redirect_to admin_admins_path, notice: 'Admin updated!'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @admin = admin
      return redirect_to admin_admins_path, alert: 'You cannot delete your own account' if @admin == current_user

      @admin.destroy!
      redirect_to admin_admins_path, notice: 'Admin deleted!'
    end

    private

    def admin
      User.with_any_role(:admin, :super_admin).find(params.expect(:id))
    end

    def admin_params
      params.expect(user: [:email, :password, :password_confirmation])
    end

    def require_super_admin!
      redirect_to admin_root_path, alert: 'You are not authorized' unless current_user.super_admin?
    end
  end
end
