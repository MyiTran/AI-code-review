class RepositoriesController < ApplicationController
  def index
    @repositories = current_user.repositories.order(created_at: :desc).search_by_keyword(params[:query]).by_language(params[:language]).by_connection_status(params[:connection_status])
    @languages = Repository.available_languages(current_user.repositories)
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

    redirect_to repository_path(repository), notice: update_message(repository, attributes), status: :see_other
  end

  private

  def repository_params
    params.expect(repository: [:connected, :auto_review_enabled])
  end

  def update_message(repository, attributes)
    return auto_review_message(repository) if attributes.key?(:auto_review_enabled)

    'Repository disconnected successfully.'
  end

  def auto_review_message(repository)
    return 'Automatic AI review enabled successfully.' if repository.auto_review_enabled?

    'Automatic AI review disabled successfully.'
  end
end
