module Manager
  class ReputationController < BaseController
    def index
      @recent_searches = fetch_recent_searches
    end

    def search
      company_name = params[:company_name]&.strip

      if company_name.blank?
        flash[:alert] = "Por favor, informe um nome de empresa."
        redirect_to manager_reputation_index_path and return
      end

      formatted_name = company_name.downcase.gsub(' ', '-')

      cached_result = fetch_cached_result(formatted_name)

      if cached_result
        @company_info = JSON.parse(cached_result)
      else
        ReclameAquiSearchJob.perform_async(formatted_name, current_user.id)
        @company_info = { status: 'processando' }
        flash[:notice] = "A pesquisa está sendo processada. Aguarde alguns segundos."
      end

      respond_to do |format|
        format.html { render :index }
        format.json { render json: @company_info }
      end
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
      searches.sort_by { |s| s['updated_at'] || Time.now }.reverse
    end
  end
end
