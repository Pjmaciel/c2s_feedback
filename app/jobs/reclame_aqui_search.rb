# frozen_string_literal: true

class ReclameAquiSearch
  include Sidekiq::Job

  def perform(company_name, user_id)
    redis_key = "reclame_aqui:#{user_id}:#{company_name}"

    # Evita reprocessar se já existir cache válido
    cached_result = fetch_cached_result(redis_key)
    return if cached_result

    company_info = ReclameAqui.fetch_company_info(company_name)

    # Salva os dados no Redis por 24 horas
    save_to_redis(redis_key, company_info)
  end

  private

  def fetch_cached_result(redis_key)
    Sidekiq.redis { |conn| conn.get(redis_key) }
  end

  def save_to_redis(redis_key, company_info)
    Sidekiq.redis do |conn|
      conn.setex(redis_key, 24.hours.to_i, company_info.to_json)
    end
  end
end
