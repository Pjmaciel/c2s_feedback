
require 'swagger_helper'

RSpec.describe 'Health API' do
  path '/api/v1/health' do
    get 'Retrieves system health' do
      tags 'Health'
      produces 'application/json'

      response '200', 'health check' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 version: { type: :string },
                 database: {
                   type: :object,
                   properties: {
                     connected: { type: :boolean },
                     pool_size: { type: :integer }
                   }
                 },
                 redis: {
                   type: :object,
                   properties: {
                     connected: { type: :boolean }
                   }
                 }
               }

        run_test!
      end
    end
  end
end