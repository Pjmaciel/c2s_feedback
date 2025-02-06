require 'rails_helper'

RSpec.describe "Health API", type: :request do
  describe "GET /api/v1/health" do
    before { get '/api/v1/health' }

    it "returns health status" do
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to include('status', 'version', 'database', 'redis')
    end
  end
end