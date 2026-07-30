class RepositoriesController < ApplicationController
  def index
    @repositories = current_user.repositories.order(created_at: :desc)
  end

  def show
    @repository = current_user.repositories.find(params.expect(:id))
  end

  def connect
    redirect_to GithubApp::InstallUrl.call, allow_other_host: true
  end
end
