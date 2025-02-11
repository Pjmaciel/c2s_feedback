require 'rails_helper'

RSpec.describe 'Health API', type: :request do
  let(:expected_schema) do
    {
      "status" => be_a(String),
      "version" => be_a(String),
      "database" => {
        "connected" => be_in([true, false]),
        "pool_size" => be_a(Integer)
      },
      "redis" => {
        "connected" => be_in([true, false])
      }
    }
  end

  before do
    allow(ActiveRecord::Base.connection).to receive(:active?).and_return(true)
    redis_instance = instance_double(Redis)
    allow(Redis).to receive(:new).and_return(redis_instance)
    allow(redis_instance).to receive(:ping).and_return("PONG")
  end

  describe 'GET /api/v1/health' do
    context 'when everything is working' do
      it 'returns system health with correct status' do
        get '/api/v1/health'
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response).to match(expected_schema)
        expect(json_response["database"]["connected"]).to be true
        expect(json_response["redis"]["connected"]).to be true
      end
    end

    context 'when database is down' do
      before do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_return(false)
      end

      it 'returns database disconnected' do
        get '/api/v1/health'
        json_response = JSON.parse(response.body)

        expect(json_response["database"]["connected"]).to be false
      end
    end

    context 'when Redis is down' do
      before do
        allow(Redis).to receive(:new).and_raise(Redis::CannotConnectError)
      end

      it 'returns redis disconnected' do
        get '/api/v1/health'
        json_response = JSON.parse(response.body)

        expect(json_response["redis"]["connected"]).to be false
      end
    end
  end
end
