class CompetitionPolicy < ApplicationPolicy

  # =================================
  # Scope
  # =================================

  class Scope < Scope
    def resolve
      scope
    end
  end

  # =================================
  # Actions
  # =================================

  def create?
    user&.admin?
  end

  def update?
    user&.admin?
  end
end
