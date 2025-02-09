# frozen_string_literal: true

class Clients::RegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})
    resource.build_client_profile
    respond_with resource
  end

  def create
    super do |resource|
      resource.role = 'client' # Define o papel do usuário como cliente
      resource.save
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      client_profile_attributes: [:cpf]
    )
  end
end