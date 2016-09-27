class RankingPolicy < ApplicationPolicy

  # =================================
  # Scope
  # =================================

  class Scope < Scope
    def resolve
      scope
    end
  end
end
