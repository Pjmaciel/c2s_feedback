
class EvaluationRequestExpirationJob
  include Sidekiq::Job

  def perform(evaluation_request_id)
    evaluation_request = EvaluationRequest.find(evaluation_request_id)
    return unless evaluation_request.pending?

    evaluation_request.expired!
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "EvaluationRequest não encontrada: #{e.message}"
  end
end