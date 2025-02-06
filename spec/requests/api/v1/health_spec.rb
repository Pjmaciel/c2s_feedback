require 'swagger_helper'

RSpec.describe 'Health API', type: :request do
  describe 'GET /api/v1/health' do
    it 'returns health status' do
      get '/api/v1/health'
      expect(response).to have_http_status(:ok)
    end
  end
end