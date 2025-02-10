module Manager
  class ReputationController < BaseController
    def index
      @recent_searches = fetch_recent_searches
    end

    def search
      company_name = params[:company_name]

      if company_name.blank?
        flash[:alert] = "Por favor, informe um nome de empresa."
        redirect_to manager_reputation_index_path and return
      end

      cached_result = fetch_cached_result(company_name)

      if cached_result
        @company_info = JSON.parse(cached_result)
      else
        # Dispara o Job para buscar os dados de forma assíncrona
        FetchReputationJob.perform_later(company_name, current_user.id)

        @company_info = { status: 'processando' }
        flash[:notice] = "A pesquisa está em andamento. Atualize a página em alguns minutos."
      end

      render :index
    end

    private

    def fetch_cached_result(company_name)
      Sidekiq.redis { |conn| conn.get("reclame_aqui:#{current_user.id}:#{company_name}") }
    end

    def fetch_recent_searches
      searches = []
      Sidekiq.redis do |conn|
        keys = conn.keys("reclame_aqui:#{current_user.id}:*")
        keys.each do |key|
          data = conn.get(key)
          searches << JSON.parse(data) if data
        end
      end
      searches.sort_by { |s| s['last_updated'] }.reverse
    end
  end
end
