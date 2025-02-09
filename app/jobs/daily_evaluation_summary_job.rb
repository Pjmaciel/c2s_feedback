# frozen_string_literal: true

class DailyEvaluationSummaryJob < ApplicationJob
  queue_as :low

  def perform
    Rails.logger.info "Iniciando o job de resumo diário de avaliações..."

    start_time = Time.zone.now.beginning_of_day
    end_time = Time.zone.now.end_of_day

    attendants = User.joins(:attendant_profile).distinct
    attendants.each do |attendant|
      daily_evaluations = Evaluation.where(attendant: attendant, evaluation_date: start_time..end_time)

      if daily_evaluations.any?
        Rails.logger.info "Enviando resumo diário para #{attendant.email} (#{daily_evaluations.count} avaliações)"
        EvaluationMailer.daily_summary(attendant, daily_evaluations).deliver_now
      else
        Rails.logger.info "Nenhuma avaliação para enviar a #{attendant.email}"
      end
    end

    Rails.logger.info "Job de resumo diário concluído!"
  end

end

