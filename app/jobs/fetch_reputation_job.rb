class FetchReputationJob
  include Sidekiq::Job

  def perform(company_name, user_id)
    begin
      company_info = ReclameAqui.fetch_company_info(company_name)
      company_info.merge!(last_updated: Time.current.to_s)

      Sidekiq.redis do |conn|
        conn.setex(
          "reclame_aqui:#{user_id}:#{company_name}",
          24.hours.to_i,
          company_info.to_json
        )
      end
    rescue => e
      Rails.logger.error("Erro no FetchReputationJob: #{e.message}")
    end
  end
end