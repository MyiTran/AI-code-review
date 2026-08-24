module Admin
  class UsersController < BaseController
    before_action :set_admin_user, only: [:show, :update]
    before_action :authorize_user, only: [:show, :update]

    def index
      authorize User, policy_class: Admin::UserPolicy

      users = policy_scope(User, policy_scope_class: Admin::UserPolicy::Scope).search(params[:q])
      @pagy, @users = pagy(users, limit: 6)
      @repository_counts = Repository.joins(:github_installation).group('github_installations.user_id').count
    end

    def show
      repositories = @user.repositories.includes(:ai_model).by_keyword(params[:q]).order(created_at: :desc)
      @pagy, @repositories = pagy(repositories, limit: 10)
      @pull_request_counts = PullRequest.where(repository_id: @repositories.ids).group(:repository_id).count
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'Plan updated successfully.'
      else
        redirect_to admin_user_path(@user), alert: 'Failed to update plan.'
      end
    end

    private

    def set_admin_user
      @user = User.find(params.expect(:id))
    end

    def authorize_user
      authorize @user, policy_class: Admin::UserPolicy
    end

    def user_params
      params.expect(user: [:plan])
    end
  end
end
