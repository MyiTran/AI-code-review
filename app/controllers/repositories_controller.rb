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
    repository.update!(connected: false, disconnected_at: Time.current)

    redirect_to repository_path(repository), notice: 'Repository disconnected in AI Review. To fully revoke GitHub App access, disconnect the installation in GitHub settings.'
  end
end
