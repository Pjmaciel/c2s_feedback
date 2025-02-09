class Clients::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    if resource.client?
      Rails.application.routes.url_helpers.client_dashboard_path
    else
      root_path
    end
  end

def new
    # Inicializa o recurso manualmente
    self.resource = User.new
    resource.build_client_profile
    respond_with resource
  end


  def create
    user = User.joins(:client_profile).find_by(client_profiles: { cpf: params[:user][:login] })

    if user&.valid_password?(params[:user][:password])
      sign_in(:user, user)
      redirect_to client_dashboard_path and return
    else
      flash.now[:alert] = 'CPF ou senha inválidos'
      render :new
    end
  end


  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    redirect_to root_path, notice: "Logout realizado com sucesso!"
  end

  private

  # Permite o parâmetro :cpf no login
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:cpf])
  end
end