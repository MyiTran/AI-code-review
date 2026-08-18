module Admin
  class AdminPolicy < BasePolicy
    def index?
      user.super_admin?
    end

    def destroy?
      user.super_admin? && user != record
    end
  end
end
