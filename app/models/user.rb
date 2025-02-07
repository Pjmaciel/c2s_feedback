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

  # Método para determinar o tipo de perfil com base no role
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

end