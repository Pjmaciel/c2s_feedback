# frozen_string_literal: true

module Attendant
  class DashboardController < BaseController
    def index
      @recent_evaluations = current_user.received_evaluations.order(created_at: :desc).limit(5)
      @pending_requests = EvaluationRequest.where(attendant: current_user, status: :pending).count
      @evaluation_count = current_user.received_evaluations.count
      @average_score = current_user.received_evaluations.average(:score)&.round(2)
    end
  end
end