# frozen_string_literal: true

class EvaluationRequestPolicy < ApplicationPolicy
  def create?
    user.attendant?
  end

  def show?
    record.client == user || record.attendant == user || user.manager?
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