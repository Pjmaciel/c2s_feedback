class Clients::SessionsController < Devise::SessionsController
  def new
    # Inicializa o recurso manualmente
    self.resource = User.new
    resource.build_client_profile
    respond_with resource
  end

  def create
    # Busca o usuário pelo CPF no perfil associado
    user = User.joins(:client_profile).find_by(client_profiles: { cpf: params[:user][:cpf] })

    if user && user.valid_password?(params[:user][:password])
      sign_in(user)
      redirect_to after_sign_in_path_for(user), notice: 'Login realizado com sucesso!'
    else
      redirect_to new_client_session_path, alert: 'CPF ou senha inválidos.'
    end
  end

  private

  # Permite o parâmetro :cpf no login
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:cpf])
  end
end