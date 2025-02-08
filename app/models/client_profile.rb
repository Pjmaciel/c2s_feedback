require 'cpf_cnpj' # Garante que a gem seja carregada

class ClientProfile < ApplicationRecord
  belongs_to :user

  before_validation :format_cpf

  validates :cpf, presence: true, uniqueness: true
  validate :valid_cpf

  private

  def format_cpf
    return if cpf.blank?

    cpf_obj = CPF.new(cpf)
    self.cpf = cpf_obj.formatted if cpf_obj.valid?
  end

  def valid_cpf
    errors.add(:cpf, "inválido") unless CPF.valid?(cpf)
  end
end
