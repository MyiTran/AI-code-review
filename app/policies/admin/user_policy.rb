module Admin
  class UserPolicy < BasePolicy
    class Scope < BasePolicy::Scope
      def resolve
        super.where.not(id: Role.where(name: %w[admin super_admin]).joins(:users).select('users.id'))
      end
    end
  end
end
