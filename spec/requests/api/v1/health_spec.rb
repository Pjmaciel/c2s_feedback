require 'swagger_helper'

RSpec.describe 'Health API', type: :request do
  path '/api/v1/health' do
    get 'Check application health' do
      tags 'Health'
      produces 'application/json'

      response '200', 'health check' do
        schema type: :object,
               properties: {
                 status: { type: :string }
               }
        run_test!
      end
    end
  end
end