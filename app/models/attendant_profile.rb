class AttendantProfile < ApplicationRecord
  belongs_to :user

  before_validation :upcase_registration_number

  validates :registration_number, presence: true

  def upcase_registration_number
    self.registration_number = registration_number.try(:upcase)
  end

end
