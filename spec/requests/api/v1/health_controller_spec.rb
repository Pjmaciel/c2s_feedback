# spec/requests/api/v1/health_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::HealthController, type: :request do
  describe 'GET /api/v1/health' do
    it 'returns health status' do
      get '/api/v1/health'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('status')
    end
  end
end