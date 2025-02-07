# frozen_string_literal: true

# app/controllers/employees/registrations_controller.rb
class Employees::RegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})
    resource.build_attendant_profile
    respond_with resource
  end

  def create
    # Define o papel do usuário com base na matrícula
    registration_number = params[:user][:attendant_profile_attributes][:registration_number]
    role = if registration_number.start_with?('V')
             'attendant'
           elsif registration_number.start_with?('G')
             'manager'
           else
             'attendant' # Fallback padrão (opcional)
           end

    # Cria o usuário com o papel definido
    self.resource = User.new(sign_up_params)
    resource.role = role

    if resource.save
      sign_in(resource)
      redirect_to after_sign_in_path_for(resource), notice: 'Cadastro realizado com sucesso!'
    else
      clean_up_passwords(resource)
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      attendant_profile_attributes: [:registration_number]
    )
  end
end