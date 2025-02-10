class FetchReputationJob < ApplicationJob
  queue_as :default

  def perform(company_name, user_id)
    Rails.logger.info "Executando FetchReputationJob para #{company_name}, Usuário: #{user_id}"

    company_info = ReclameAqui.fetch_company_info(company_name)

    Rails.logger.info "Resultado do scraping: #{company_info.inspect}"

    if company_info[:error]
      Rails.logger.error "Erro ao buscar dados para #{company_name}"
      ActionCable.server.broadcast("reputation_#{user_id}", { status: "Erro ao buscar dados." })
    else
      # Salvar no Redis
      redis_key = "reclame_aqui:#{user_id}:#{company_name}"
      Sidekiq.redis { |conn| conn.setex(redis_key, 24.hours.to_i, company_info.to_json) }

      # Enviar para o WebSocket
      Rails.logger.info "Enviando dados para WebSocket..."
      ActionCable.server.broadcast("reputation_#{user_id}", {
        company_name: company_info[:company_name],
        solution_rate: company_info[:reviews_count],
        reputation_score: company_info[:rating],
        status: "Atualizado"
      })
    end
  end
end
