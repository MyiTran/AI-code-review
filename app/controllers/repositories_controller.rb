class RepositoriesController < ApplicationController
  def index
    @repositories = current_user.repositories.order(created_at: :desc).search_by_keyword(params[:query]).by_language(params[:language]).by_connection_status(params[:connection_status])
    @languages = Repository.available_languages(current_user.repositories)
  end

  def show
    @repository = current_user.repositories.find(params.expect(:id))
  end

  def connect
    redirect_to GithubApp::InstallUrl.call, allow_other_host: true
  end
end
