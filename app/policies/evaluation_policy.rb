class EvaluationPolicy < ApplicationPolicy
  def create?
    user.client? && record.client_id == user.id
  end

  def show?
    user.client? && record.client_id == user.id ||
      user.attendant? && record.attendant_id == user.id ||
      user.manager?
  end

  class Scope < Scope
    def resolve
      if user.manager?
        scope.all
      elsif user.attendant?
        scope.where(attendant_id: user.id)
      else
        scope.where(client_id: user.id)
      end
    end
  end
end