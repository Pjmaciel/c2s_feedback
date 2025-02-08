class EvaluationMailer < ApplicationMailer
  def request_evaluation(evaluation_request)
    @evaluation_request = evaluation_request
    mail(
      to: @evaluation_request.client.email,
      subject: "Solicitação de Avaliação"
    )
  end
end
