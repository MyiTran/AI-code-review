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
    reviews
      .then { |items| filter_reviews_by_query(items) }
      .then { |items| filter_reviews_by_repository(items) }
      .then { |items| filter_reviews_by_status(items) }
      .then { |items| filter_reviews_by_model(items) }
  end

  def filter_reviews_by_query(reviews)
    return reviews if params[:query].blank?

    query = params.expect(:query).downcase.strip

    reviews.select do |review|
      review_matches_query?(review, query)
    end
  end

  def review_matches_query?(review, query)
    review[:title].downcase.include?(query) ||
      review[:repository_name].downcase.include?(query) ||
      review[:pull_request_number].to_s.include?(query)
  end

  def filter_reviews_by_repository(reviews)
    return reviews if params[:repository].blank?

    reviews.select do |review|
      review[:repository_name] == params[:repository]
    end
  end

  def filter_reviews_by_status(reviews)
    return reviews if params[:status].blank?

    reviews.select do |review|
      review[:status] == params[:status]
    end
  end

  def filter_reviews_by_model(reviews)
    return reviews if params[:model].blank?

    reviews.select do |review|
      review[:model] == params[:model]
    end
  end
end
