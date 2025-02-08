# frozen_string_literal: true

class Employees::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    if resource.attendant?
      employee_dashboard_path
    elsif resource.manager?
      manager_dashboard_path
    else
      root_path
    end
  end
  def new
    # Inicializa o recurso manualmente
    self.resource = User.new
    resource.build_attendant_profile
    respond_with resource
  end

  def create
    # Busca o usuário pelo número de registro no perfil associado
    user = User.joins(:attendant_profile).find_by(attendant_profiles: { registration_number: params[:user][:registration_number] })

    if user && user.valid_password?(params[:user][:password])
      sign_in(user)
      redirect_to after_sign_in_path_for(user), notice: 'Login realizado com sucesso!'
    else
      redirect_to new_employee_session_path, alert: 'Número de registro ou senha inválidos.'
    end
  end

  private

  # Permite o parâmetro :registration_number no login
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:registration_number])
  end
end