class UserPolicy < ApplicationPolicy

  # =================================
  # Actions
  # =================================

  def update?
    record == user
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
