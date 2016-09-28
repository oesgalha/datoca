class TeamPolicy < ApplicationPolicy

  # =================================
  # Actions
  # =================================

  def create?
    true
  end

  def update?
    record.users.exists?(user&.id)
  end

  # =================================
  # Scope
  # =================================

  class Scope < Scope
    def resolve
      scope
    end
  end
end
