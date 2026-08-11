class RepositoriesController < ApplicationController
  helper GithubHelper
  def index
    @repositories = current_user.repositories.includes(:ai_model).order(created_at: :desc).search_by_keyword(params[:query]).by_language(params[:language]).by_connection_status(params[:connection_status]).by_ai_model(params[:ai_model])
    @languages = Repository.available_languages(current_user.repositories)
    @ai_models = AiModel.where(active: true).order(:name).pluck(:name, :id)
    @default_ai_model = AiModel.find_by(is_default: true, active: true)
  end

  def show
    @repository = current_user.repositories.find(params.expect(:id))
  end

  def update
    repository = current_user.repositories.find(params.expect(:id))
    attributes = repository_params

    if attributes.key?(:connected)
      connected = ActiveModel::Type::Boolean.new.cast(attributes[:connected])
      attributes[:disconnected_at] = connected ? nil : Time.current
    end

    repository.update!(attributes)

    message =
      if attributes.key?(:auto_review_enabled)
        status = repository.auto_review_enabled? ? 'enabled' : 'disabled'
        "Automatic AI review #{status} successfully."
      else
        'Repository disconnected successfully.'
      end

    redirect_to repository_path(repository), notice: message
  rescue ActiveRecord::RecordInvalid
    redirect_to repository_path(repository), alert: 'Repository could not be updated.'
  end

  private

  def repository_params
    params.expect(repository: [:connected, :auto_review_enabled])
  end
end
