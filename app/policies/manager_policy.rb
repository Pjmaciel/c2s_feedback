# frozen_string_literal: true

class ManagerPolicy < ApplicationPolicy
  def index?
    user.manager?
  end

  def show?
    user.manager?
  end

  def create?
    user.manager?
  end

  def update?
    user.manager? && (user.id == record.id || user.super_admin?) # Apenas super admin pode editar outros managers
  end

  def destroy?
    user.manager? && user.super_admin? && user.id != record.id # Não pode deletar a si mesmo
  end

  class Scope < Scope
    def resolve
      if user.manager?
        scope.all
      else
        scope.none
      end
    end
  end
end