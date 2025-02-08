# frozen_string_literal: true

class AttendantPolicy < ApplicationPolicy
  def index?
    user.manager?
  end

  def show?
    user.manager? || owner?
  end

  def create?
    user.manager?
  end

  def update?
    user.manager? || owner?
  end

  def destroy?
    user.manager?
  end

  private

  def owner?
    user == record
  end

  class Scope < Scope
    def resolve
      if user.manager?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
