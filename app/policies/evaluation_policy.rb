class EvaluationPolicy < ApplicationPolicy
  def create?
    user.client? && record.client_id == user.id
  end

  def show?
    user.client? && record.client_id == user.id ||
      user.attendant? && record.attendant_id == user.id ||
      user.manager?
  end
end