# frozen_string_literal: true

class EvaluationRequestPolicy < ApplicationPolicy
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
        scope.where(attendant: user)
      else
        scope.where(client: user)
      end
    end
  end
end