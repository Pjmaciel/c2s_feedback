# frozen_string_literal: true

class Employees::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    if resource.attendant?
      attendant_dashboard_path
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
    user = User.joins(:attendant_profile)
               .find_by(attendant_profiles: { registration_number: params[:user][:registration_number] })

    if user&.valid_password?(params[:user][:password])
      sign_in(user)
      redirect_to after_sign_in_path_for(user), notice: 'Login realizado com sucesso!'
    else
      flash.now[:alert] = 'Número de registro ou senha inválidos.'
      self.resource = resource_class.new
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    redirect_to root_path, notice: "Logout realizado com sucesso!"
  end

  private

  # Permite o parâmetro :registration_number no login
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:registration_number])
  end
end