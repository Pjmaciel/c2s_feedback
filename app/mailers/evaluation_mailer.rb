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

  def notify_manager(manager, evaluation)
    @manager = manager
    @evaluation = evaluation

    mail(
      to: @manager.email,
      subject: "Nova Avaliação Recebida"
    )
  end

  def notify_attendant(attendant, evaluation)
    @attendant = attendant
    @evaluation = evaluation

    mail(
      to: @attendant.email,
      subject: "Você recebeu uma nova avaliação"
    )
  end

  def daily_summary(attendant, evaluations)
    @attendant = attendant
    @evaluations = evaluations
    mail(to: @attendant.email, subject: 'Resumo diário das suas avaliações')
  end

end
