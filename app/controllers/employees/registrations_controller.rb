# frozen_string_literal: true

# app/controllers/employees/registrations_controller.rb
class Employees::RegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})
    resource.build_attendant_profile
    respond_with resource
  end

  def create
    super do |resource|
      # Define o papel do usuário com base na matrícula
      if params[:user][:attendant_profile_attributes][:registration_number].start_with?('V')
        resource.role = 'attendant'
      elsif params[:user][:attendant_profile_attributes][:registration_number].start_with?('G')
        resource.role = 'manager'
      end
      resource.save
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