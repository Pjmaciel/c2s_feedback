class AttendantProfile < ApplicationRecord
  belongs_to :user
  validates :registration_number, presence: true
end
