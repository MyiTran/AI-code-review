class DashboardPresenter
  ZERO = Constants::ZERO

  attr_reader :year, :user

  def initialize(user:, year: Date.current.year)
    @year = year
    @user = user
  end

  def repository_count
    @repository_count ||= Subscriptions::RepositoriesCountService.call(user).to_i
  end

  def repository_limit
    @repository_limit ||= Subscriptions::GetPlanLimitsService.call(user)[:repositories]
  end

  def pull_request_count
    @pull_request_count ||= PullRequest.joins(repository: :github_installation).where(github_installations: { user_id: user.id }).where(created_at: Time.current.all_month).count
  end

  def pull_request_limit
    @pull_request_limit ||= Subscriptions::GetPlanLimitsService.call(user)[:pull_requests]
  end

  def review_count
    @review_count ||= reviews.count
  end

  def issues_found_count
    @issues_found_count ||= reviews.sum(:issues_found_count)
  end

  def plan_name
    user.pro? ? 'Pro' : 'Free'
  end

  def monthly_review_limit
    @monthly_review_limit ||= Subscriptions::GetPlanLimitsService.call(user)[:reviews]
  end

  def monthly_review_count
    @monthly_review_count ||= reviews.where(created_at: Time.current.all_month).count
  end

  def monthly_usage_percent
    limit = monthly_review_limit
    return ZERO if limit.to_i.zero?

    [(monthly_review_count.to_f / limit * 100).round, 100].min
  end

  def monthly_review_remaining
    [monthly_review_limit - monthly_review_count, 0].max
  end

  def recent_repositories
    @recent_repositories ||= repositories.includes(:ai_model).order(updated_at: :desc).limit(5)
  end

  def recent_reviews
    @recent_reviews ||= reviews.includes(:ai_model, pull_request: :repository).order(created_at: :desc).limit(5)
  end

  def user_count
    @user_count ||= User.count
  end

  def user_12_months
    @user_12_months ||= begin
      data = []
      (1..12).each do |month|
        month_start = Date.new(year, month, 1).beginning_of_month
        month_end = month_start.end_of_month
        count = User.where(created_at: month_start..month_end).size
        data << count
      end
      data
    end
  end

  def user_change_percent
    current_month = user_12_months[Date.current.month - 1] || ZERO
    prev_month = user_12_months[Date.current.month - 2] || ZERO

    return ZERO if prev_month == ZERO

    (((current_month - prev_month) / prev_month.to_f) * 100).round(1)
  end

  def users_this_year
    @users_this_year ||= User.where(created_at: year_range).count
  end

  def users_this_month
    @users_this_month ||= users_in_month(current_month_date)
  end

  def users_last_month
    @users_last_month ||= users_in_month(current_month_date.prev_month)
  end

  def users_today
    @users_today ||= User.where(created_at: Date.current.all_day).count
  end

  def average_users_per_month
    return ZERO if user_12_months.empty?

    (user_12_months.sum.to_f / user_12_months.size).round(1)
  end

  def peak_month_name
    index = user_12_months.each_with_index.max_by { |value, _i| value }&.last
    return nil unless index

    Date::MONTHNAMES[index + 1]
  end

  def recent_users(limit = 5)
    User.order(created_at: :desc).limit(limit)
  end

  private

  def repositories
    @repositories ||= user.repositories
  end

  def reviews
    @reviews ||= Review.by_user(user)
  end

  def current_month_date
    @current_month_date ||= Date.new(year, Date.current.month, 1)
  end

  def users_in_month(date)
    month_start = Date.new(year, date.month, 1).beginning_of_month
    month_end = month_start.end_of_month
    User.where(created_at: month_start..month_end).count
  end

  def year_range
    start_date = Date.new(year, 1, 1).beginning_of_year
    end_date = Date.new(year, 12, 31).end_of_year
    start_date..end_date
  end
end
