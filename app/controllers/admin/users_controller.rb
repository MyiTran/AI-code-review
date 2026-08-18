module Admin
  class UsersController < BaseController
    def index
      authorize User, policy_class: Admin::UserPolicy

      users = policy_scope(User, policy_scope_class: Admin::UserPolicy::Scope).search(params[:q])
      @pagy, @users = pagy(users, limit: 10)

      @repository_counts = Repository.joins(:github_installation).group('github_installations.user_id').count
    end

    def show
      @user = User.find(params.expect(:id))
      authorize @user, policy_class: Admin::UserPolicy

      @repositories = @user.repositories.includes(:ai_model).order(created_at: :desc)
      @pull_request_counts = PullRequest.where(repository_id: @repositories.ids).group(:repository_id).count
    end

    def update
      @user = User.find(params.expect(:id))
      authorize @user, policy_class: Admin::UserPolicy

      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'Plan updated successfully.'
      else
        redirect_to admin_user_path(@user), alert: 'Failed to update plan.'
      end
    end

    private

    def user_params
      params.expect(user: [:plan])
    end
  end
end
