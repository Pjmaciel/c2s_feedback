# frozen_string_literal: true

class EvaluationNotificationJob < ApplicationJob
  queue_as :default

  def perform(evaluation_id, manager_user_id)
    evaluation = Evaluation.find_by(id: evaluation_id)
    return unless evaluation

    manager = User.find_by(id: manager_user_id)
    return unless manager

    EvaluationMailer.notify_manager(manager, evaluation).deliver_now
  end
end

