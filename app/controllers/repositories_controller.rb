class RepositoriesController < ApplicationController
  helper GithubHelper
  def index
    @repositories = current_user.repositories.order(created_at: :desc).by_keyword(params[:query]).by_language(params[:language]).by_connection_status(params[:connection_status])
    @languages = Repository.available_languages(current_user.repositories)
    @models = []
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
  end

  private

  def repository_params
    params.expect(repository: [:connected, :auto_review_enabled])
  end
end
