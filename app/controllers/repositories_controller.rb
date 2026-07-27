class RepositoriesController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    repositories = Mock::Repositories.all

    if params[:user_id].present?
      @selected_user = find_selected_user

      repositories = repositories.select do |repository|
        repository[:user_id].to_s == params[:user_id].to_s
      end
    end

    @languages = repositories
      .pluck(:language)
      .uniq
      .sort

    @models = repositories
      .filter_map { |repository| repository[:ai_model] }
      .uniq
      .sort

    @repositories = filter_repositories(repositories)
  end

  def show
    @repository = Mock::Repositories.find(params.expect(:id))

    raise ActiveRecord::RecordNotFound, 'Repository not found' unless @repository

    if params[:user_id].present?
      @selected_user = find_selected_user

      raise ActiveRecord::RecordNotFound, 'User not found' unless @selected_user

      if @repository[:user_id].to_s != params[:user_id].to_s
        raise ActiveRecord::RecordNotFound, 'Repository not found'
      end
    end

    @review_history = filter_review_history(@repository[:review_history])
  end

  private

  def find_selected_user
    Mock::AdminDashboard
      .data[:users]
      .find { |user| user[:id].to_s == params[:user_id].to_s }
  end

  def filter_repositories(repositories)
    result = repositories

    if params[:query].present?
      query = params.expect(:query).downcase.strip

      result = result.select do |repository|
        repository[:name].downcase.include?(query) ||
          repository[:description].downcase.include?(query)
      end
    end

    if params[:connection_status].present?
      result = result.select do |repository|
        repository[:connection_status] == params[:connection_status]
      end
    end

    if params[:language].present?
      result = result.select do |repository|
        repository[:language] == params[:language]
      end
    end

    if params[:ai_model].present?
      result = result.select do |repository|
        repository[:ai_model] == params[:ai_model]
      end
    end

    result
  end

  def filter_review_history(reviews)
    return reviews if params[:review_query].blank?

    query = params.expect(:review_query).downcase.strip

    reviews.select do |review|
      review[:title].downcase.include?(query) ||
        review[:pull_request_number].to_s.include?(query) ||
        review[:source_branch].downcase.include?(query) ||
        review[:target_branch].downcase.include?(query) ||
        review[:author].downcase.include?(query)
    end
  end
end
