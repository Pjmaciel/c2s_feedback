class Evaluation < ApplicationRecord
  belongs_to :attendant, class_name: 'User', optional: false
  belongs_to :client, class_name: 'User', optional: false

  validates :score, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :comment, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :evaluation_date, presence: true
  validate :client_must_be_client
  validate :attendant_must_be_attendant
  validate :evaluation_date_cannot_be_in_future

  after_commit :notify_managers, :notify_attendant, on: :create

  private

  def notify_managers
    User.joins(:manager_profile).distinct.each do |manager|
      EvaluationNotificationJob.perform_later(self.id, manager.id)
    end
  end

  def notify_attendant
    AttendantNotificationJob.perform_later(self.id)
  end

  def client_must_be_client
    return if client&.role == 'client'

    errors.add(:client, 'must have client role')
  end

  def attendant_must_be_attendant
    return if attendant&.role == 'attendant'

    errors.add(:attendant, 'must have attendant role')
  end

  def evaluation_date_cannot_be_in_future
    return if evaluation_date.present? && evaluation_date <= Time.current

    errors.add(:evaluation_date, 'cannot be in the future')
  end
end
