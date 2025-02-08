class User < ApplicationRecord
  # Associações
  has_one :client_profile, dependent: :destroy
  has_one :attendant_profile, dependent: :destroy
  has_one :manager_profile, dependent: :destroy

  # Aceita atributos aninhados para os perfis
  accepts_nested_attributes_for :client_profile
  accepts_nested_attributes_for :attendant_profile
  accepts_nested_attributes_for :manager_profile

  # Configurações do Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validação do role
  validates :role, inclusion: { in: %w[client attendant manager] }

  # determinar o tipo de perfil com base no role
  def profile
    case role
    when 'client'
      client_profile
    when 'attendant'
      attendant_profile
    when 'manager'
      manager_profile
    end
  end

  # autenticar com base no CPF ou número de registro
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (cpf = conditions.delete(:cpf))
      joins(:client_profile).find_by(client_profiles: { cpf: cpf })
    elsif (registration_number = conditions.delete(:registration_number))
      joins(:attendant_profile).find_by(attendant_profiles: { registration_number: registration_number })
    else
      where(conditions.to_h).first
    end
  end

end