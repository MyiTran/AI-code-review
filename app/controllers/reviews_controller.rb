class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    reviews = Mock::Reviews.all

    @repositories = reviews
      .pluck(:repository_name)
      .uniq
      .sort

    @models = reviews
      .pluck(:model)
      .uniq
      .sort

    @reviews = filter_reviews(reviews)
  end

  def show
    @review = Mock::Reviews.find(params.expect(:id))

    raise ActiveRecord::RecordNotFound, 'Review not found' unless @review
  end

  private

  def filter_reviews(reviews)
    result = reviews

    if params[:query].present?
      query = params.expect(:query).downcase.strip

      result = result.select do |review|
        review[:title].downcase.include?(query) ||
          review[:repository_name].downcase.include?(query) ||
          review[:pull_request_number].to_s.include?(query)
      end
    end

    if params[:repository].present?
      result = result.select do |review|
        review[:repository_name] == params[:repository]
      end
    end

    if params[:status].present?
      result = result.select do |review|
        review[:status] == params[:status]
      end
    end

    if params[:model].present?
      result = result.select do |review|
        review[:model] == params[:model]
      end
    end

    result
  end
end
