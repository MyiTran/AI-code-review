class RepositoriesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    repositories = repositories_for_selected_user

    @languages = repositories.pluck(:language).uniq.sort

    @models = repositories.filter_map { |repository| repository[:ai_model] }.uniq.sort

    @repositories = filter_repositories(repositories)
  end

  def show
    @repository = Mock::Repositories.find(params.expect(:id))

    validate_selected_user_repository!

    @review_history = filter_review_history(
      @repository[:review_history]
    )
  end

  private

  def repositories_for_selected_user
    repositories = Mock::Repositories.all

    return repositories if params[:user_id].blank?

    @selected_user = find_selected_user

    repositories.select do |repository|
      repository[:user_id].to_s == params[:user_id].to_s
    end
  end

  def find_selected_user
    Mock::AdminDashboard.data[:users].find do |user|
      user[:id].to_s == params[:user_id].to_s
    end
  end

  def validate_selected_user_repository!
    return if params[:user_id].blank?

    @selected_user = find_selected_user

    raise ActiveRecord::RecordNotFound, 'User not found' unless @selected_user
    return if repository_belongs_to_selected_user?

    raise ActiveRecord::RecordNotFound, 'Repository not found'
  end

  def repository_belongs_to_selected_user?
    @repository[:user_id].to_s == params[:user_id].to_s
  end

  def filter_repositories(repositories)
    repositories
      .then { |items| filter_repositories_by_query(items) }
      .then { |items| filter_repositories_by_status(items) }
      .then { |items| filter_repositories_by_language(items) }
      .then { |items| filter_repositories_by_model(items) }
  end

  def filter_repositories_by_query(repositories)
    return repositories if params[:query].blank?

    query = params.expect(:query).downcase.strip

    repositories.select do |repository|
      repository[:name].downcase.include?(query) ||
        repository[:description].downcase.include?(query)
    end
  end

  def filter_repositories_by_status(repositories)
    return repositories if params[:connection_status].blank?

    repositories.select do |repository|
      repository[:connection_status] == params[:connection_status]
    end
  end

  def filter_repositories_by_language(repositories)
    return repositories if params[:language].blank?

    repositories.select do |repository|
      repository[:language] == params[:language]
    end
  end

  def filter_repositories_by_model(repositories)
    return repositories if params[:ai_model].blank?

    repositories.select do |repository|
      repository[:ai_model] == params[:ai_model]
    end
  end

  def filter_review_history(reviews)
    return reviews if params[:review_query].blank?

    query = params.expect(:review_query).downcase.strip

    reviews.select do |review|
      review_matches_query?(review, query)
    end
  end

  def review_matches_query?(review, query)
    review[:title].downcase.include?(query) ||
      review[:pull_request_number].to_s.include?(query) ||
      review[:source_branch].downcase.include?(query) ||
      review[:target_branch].downcase.include?(query) ||
      review[:author].downcase.include?(query)
  end
end
