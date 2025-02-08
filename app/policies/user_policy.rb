# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.manager?
        scope.all
      elsif user.attendant?
        scope.where(role: 'client')
      else
        scope.where(id: user.id)
      end
    end
  end

  def index?
    user.manager? || user.attendant?
  end

  def show?
    user.manager? || user.attendant? || user.id == record.id
  end

  def create?
    user.manager?
  end

  def update?
    return true if user.manager?
    return true if user.id == record.id
    false
  end

  def destroy?
    return false if user.id == record.id # Não pode deletar a si mesmo
    user.manager?
  end
end