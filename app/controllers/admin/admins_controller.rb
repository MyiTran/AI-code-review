module Admin
  class AdminsController < BaseController
    def index
      authorize User, policy_class: Admin::AdminPolicy

      admins = policy_scope(User, policy_scope_class: Admin::AdminPolicy::Scope).search(params[:q])
      @pagy, @admins = pagy(admins, limit: 6)
    end

    def new
      @admin = User.new
      authorize @admin, policy_class: Admin::AdminPolicy
    end

    def edit
      @admin = admin
      authorize @admin, policy_class: Admin::AdminPolicy
    end

    def create
      @admin = User.new(admin_params)
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
      @admin = admin
      authorize @admin, policy_class: Admin::AdminPolicy

      @admin.skip_reconfirmation!

      if admin_params[:password].blank?
        @admin.errors.add(:password, "can't be blank")
        return render :edit, status: :unprocessable_content
      end

      if @admin.update(admin_params)
        update_role
        redirect_to admin_admins_path, notice: 'Admin updated!'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @admin = admin
      authorize @admin, policy_class: Admin::AdminPolicy

      @admin.destroy!
      redirect_to admin_admins_path, notice: 'Admin deleted!'
    end

    private

    def admin
      policy_scope(User, policy_scope_class: Admin::AdminPolicy::Scope).find(params.expect(:id))
    end

    def admin_params
      attributes = params.expect(user: [:first_name, :last_name, :email, :password, :password_confirmation])
      attributes.delete(:password) if attributes[:password].blank?
      attributes.delete(:password_confirmation) if attributes[:password_confirmation].blank?
      attributes
    end

    def update_role
      return if @admin == current_user

      @admin.roles = []
      @admin.add_role(params[:role])
    end
  end
end
