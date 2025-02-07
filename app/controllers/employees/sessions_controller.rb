# frozen_string_literal: true

class Employees::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    # Lógica personalizada para login de funcionários
    user = User.find_by(email: params[:user][:email])
    if user&.attendant? || user&.manager?
      super
    else
      redirect_to new_employee_session_path, alert: 'Apenas funcionários podem fazer login aqui.'
    end
  end
end