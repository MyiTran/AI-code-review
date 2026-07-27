module Admin
  class UsersController < BaseController
    def index
      @users = Mock::AdminDashboard.data[:users]

      if params[:query].present?
        query = params[:query].downcase.strip

        @users = @users.select do |user|
          user[:name].downcase.include?(query) ||
            user[:email].downcase.include?(query)
        end
      end
    end
  end
end