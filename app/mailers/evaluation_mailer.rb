# app/mailers/evaluation_mailer.rb

class EvaluationMailer < ApplicationMailer
  default from: 'no-reply@c2sfeedback.com'
  def request_evaluation
    @evaluation_request = params[:evaluation_request]
    @client = @evaluation_request.client
    @attendant = @evaluation_request.attendant

    mail(
      to: @client.email,
      subject: "Avalie seu atendimento com #{@attendant.name}"
    )
  end
end