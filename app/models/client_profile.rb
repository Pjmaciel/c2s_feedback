class ClientProfile < ApplicationRecord
  belongs_to :user
  validates :cpf, presence: true
end
