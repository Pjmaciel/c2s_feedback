module Api
  module V1
    class HealthController < ApplicationController
      def show
        render json: {
          status: 'ok',
          version: '1.0.0',
          database: {
            connected: ActiveRecord::Base.connected?,
            pool_size: ActiveRecord::Base.connection_pool.size
          },
          redis: {
            connected: Redis.new(url: ENV['REDIS_URL']).ping == 'PONG'
          }
        }
      end
    end
  end
end