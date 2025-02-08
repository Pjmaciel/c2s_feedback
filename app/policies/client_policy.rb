class ClientPolicy < ApplicationPolicy
  def index?
    user.manager? || user.attendant?
  end

  def show?
    user.manager? || user.attendant? || owner?
  end

  def create?
    true # Qualquer um pode se registrar como cliente
  end

  def update?
    owner? || user.manager?
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
      elsif user.attendant?
        scope.where(role: 'client')
      else
        scope.where(id: user.id)
      end
    end
  end
end