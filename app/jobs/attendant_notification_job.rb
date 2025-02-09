class AttendantNotificationJob < ApplicationJob
  queue_as :default

  def perform(evaluation_id)
    evaluation = Evaluation.find_by(id: evaluation_id)
    return unless evaluation

    attendant = evaluation.attendant
    EvaluationMailer.notify_attendant(attendant, evaluation).deliver_now
  end
end
