class RepositoriesController < ApplicationController
  def index
    @repositories = current_user.repositories.includes(:ai_model).order(created_at: :desc).search_by_keyword(params[:query]).by_language(params[:language]).by_connection_status(params[:connection_status]).by_ai_model(params[:ai_model])
    @languages = Repository.available_languages(current_user.repositories)
    @ai_models = available_ai_models.order(:name).pluck(:name, :id)
    @default_ai_model = AiModel.find_by(is_default: true, active: true)
  end

  def show
    @repository = current_user.repositories.find(params.expect(:id))
    @ai_models = available_ai_models.order(:name)
    @pull_requests = @repository.pull_requests.includes(:reviews).order(updated_at: :desc)
    @reviews = Review.joins(:pull_request).where(pull_requests: { repository_id: @repository.id }).includes(:ai_model, :pull_request).order(created_at: :desc)
  end

  def update
    repository = current_user.repositories.find(params.expect(:id))
    attributes = repository_params

    return redirect_to repository_path(repository), alert: 'AI model is not available for your plan.' if invalid_ai_model?(attributes)

    if attributes.key?(:connected)
      connected = ActiveModel::Type::Boolean.new.cast(attributes[:connected])
      attributes[:disconnected_at] = connected ? nil : Time.current
    end

    repository.update!(attributes)

    redirect_to request.referer.presence || repository_path(repository), notice: update_message(repository, attributes), status: :see_other
  end

  private

  def repository_params
    params.expect(repository: [:connected, :auto_review_enabled, :ai_model_id])
  end

  def available_ai_models
    return AiModel.where(active: true) if current_user.pro?

    AiModel.where(active: true, is_premium: false)
  end

  def invalid_ai_model?(attributes)
    attributes[:ai_model_id].present? && !available_ai_models.exists?(id: attributes[:ai_model_id])
  end

  def update_message(repository, attributes)
    return auto_review_message(repository) if attributes.key?(:auto_review_enabled)
    return 'AI model updated successfully.' if attributes.key?(:ai_model_id)

    'Repository disconnected successfully.'
  end

  def auto_review_message(repository)
    return 'Automatic AI review enabled successfully.' if repository.auto_review_enabled?

    'Automatic AI review disabled successfully.'
  end
end
