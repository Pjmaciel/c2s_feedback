# frozen_string_literal: true

class Clients::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    # Lógica personalizada para login de clientes
    user = User.find_by(email: params[:user][:email])
    if user&.client?
      super
    else
      redirect_to new_client_session_path, alert: 'Apenas clientes podem fazer login aqui.'
    end
  end
end