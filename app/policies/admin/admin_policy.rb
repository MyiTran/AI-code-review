module Admin
  class AdminPolicy < BasePolicy
    def index?
      user.super_admin?
    end

    def destroy?
      user.super_admin? && user != record
    end

    class Scope < BasePolicy::Scope
      def resolve
        super.joins(:roles).where(roles: { name: %w[admin super_admin] }).distinct
      end
    end
  end
end
