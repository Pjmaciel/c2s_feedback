class ReclameAquiSearchJob
  include Sidekiq::Job

  def perform(company_name, user_id)
    redis_key = "reclame_aqui:#{user_id}:#{company_name.downcase.gsub(' ', '-')}"

    cached_result = fetch_cached_result(redis_key)
    if cached_result
      broadcast_result(user_id, JSON.parse(cached_result))
      return
    end

    company_info = ReclameAqui.fetch_company_info(company_name)

    save_to_redis(redis_key, company_info) if company_info[:error].nil?

    broadcast_result(user_id, company_info)
  end

  private

  def fetch_cached_result(redis_key)
    Sidekiq.redis { |conn| conn.get(redis_key) }
  end

  def save_to_redis(redis_key, company_info)
    Sidekiq.redis do |conn|
      conn.set(redis_key, company_info.to_json, ex: 1.hour.to_i)
    end
  end

  def broadcast_result(user_id, company_info)
    ActionCable.server.broadcast("reputation_#{user_id}", company_info)
  end
end
