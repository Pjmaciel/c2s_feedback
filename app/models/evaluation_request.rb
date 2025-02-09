# frozen_string_literal: true

class EvaluationRequest < ApplicationRecord
  belongs_to :attendant, class_name: 'User'
  belongs_to :client, class_name: 'User'

  has_secure_token :evaluation_token, length: 36

  validates :attendant, presence: true
  validates :client, presence: true
  validates :status, presence: true

  enum status: {
    pending: 'pending',
    completed: 'completed',
    expired: 'expired'
  }

  scope :pending, -> { where(status: :pending) }
  scope :completed, -> { where(status: :completed) }
  scope :expired, -> { where(status: :expired) }

  after_create :schedule_email_delivery
  after_create :schedule_expiration_check

  private

  def schedule_email_delivery
    EvaluationRequestMailerJob.perform_async(id)
  end

  def schedule_expiration_check
    EvaluationRequestExpirationJob.perform_in(24.hours, id)
  end
end