module Admin
  class AdminsController < BaseController
    before_action :set_admin, only: [:edit, :update, :destroy]
    before_action :authorize_admin, only: [:edit, :update, :destroy]

    def index
      authorize User, policy_class: Admin::AdminPolicy

      admins = policy_scope(User, policy_scope_class: Admin::AdminPolicy::Scope).search(params[:q])
      @pagy, @admins = pagy(admins, limit: 6)
    end

    def new
      @admin = User.new
      authorize @admin, policy_class: Admin::AdminPolicy
    end

    def edit; end

    def create
      @admin = User.new(create_admin_params)
      authorize @admin, policy_class: Admin::AdminPolicy

      @admin.provider = :email
      @admin.confirmed_at = Time.current

      if admin_params[:password].blank?
        @admin.errors.add(:password, "can't be blank")
        return render :new, status: :unprocessable_content
      end

      if @admin.save
        @admin.add_role(:admin)
        redirect_to admin_admins_path, notice: 'Admin created!'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      @admin.skip_reconfirmation!

      if admin_params[:password].blank?
        @admin.errors.add(:password, "can't be blank")
        return render :edit, status: :unprocessable_content
      end

      if @admin.update(admin_params)
        redirect_to admin_admins_path, notice: 'Admin updated!'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @admin.destroy!
      redirect_to admin_admins_path, notice: 'Admin deleted!'
    end

    private

    def set_admin
      @admin = policy_scope(User, policy_scope_class: Admin::AdminPolicy::Scope).find(params.expect(:id))
    end

    def authorize_admin
      authorize @admin, policy_class: Admin::AdminPolicy
    end

    def create_admin_params
      params.expect(user: [:first_name, :last_name, :email, :password, :password_confirmation])
    end

    def admin_params
      params.expect(user: [:first_name, :last_name, :email, :password, :password_confirmation])
    end
  end
end
