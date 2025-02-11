require 'rails_helper'

RSpec.describe "Evaluation Flow", type: :request do
  let(:client) { create(:client) }
  let(:attendant) { create(:attendant) }
  let(:evaluation_request) { create(:evaluation_request, client: client, attendant: attendant) }

  before do
    sign_in client
  end

  describe "Complete evaluation flow" do
    it "allows client to submit an evaluation" do
      # Primeiro, verifica se o cliente pode ver o formulário de avaliação
      get new_client_evaluation_path(token: evaluation_request.evaluation_token)
      expect(response).to have_http_status(:success)

      # Tenta criar uma avaliação
      evaluation_params = {
        token: evaluation_request.evaluation_token,
        evaluation: {
          score: 8,
          comment: "Excellent service, very professional and helpful."
        }
      }

      expect {
        post api_v1_evaluations_path,
             params: evaluation_params,
             headers: { 'ACCEPT' => 'application/json' }
      }.to change(Evaluation, :count).by(1)
                                     .and change { evaluation_request.reload.status }.from("pending").to("completed")

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to include("registrada com sucesso")

      evaluation = Evaluation.last
      expect(evaluation.score).to eq(8)
      expect(evaluation.comment).to eq("Excellent service, very professional and helpful.")
      expect(evaluation.client).to eq(client)
      expect(evaluation.attendant).to eq(attendant)

      # Verifica se os jobs de notificação foram enfileirados
      assert_enqueued_with(job: EvaluationNotificationJob)
      assert_enqueued_with(job: AttendantNotificationJob)
    end

    it "prevents unauthorized users from submitting evaluations" do
      other_client = create(:client)
      sign_in other_client

      evaluation_params = {
        token: evaluation_request.evaluation_token,
        evaluation: {
          score: 8,
          comment: "Excellent service, very professional and helpful."
        }
      }

      expect {
        post api_v1_evaluations_path,
             params: evaluation_params,
             headers: { 'ACCEPT' => 'application/json' }
      }.not_to change(Evaluation, :count)

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Não autorizado")
    end

    it "validates evaluation parameters" do
      invalid_params = {
        token: evaluation_request.evaluation_token,
        evaluation: {
          score: 11, # inválido: maior que 10
          comment: "Short" # inválido: muito curto
        }
      }

      expect {
        post api_v1_evaluations_path,
             params: invalid_params,
             headers: { 'ACCEPT' => 'application/json' }
      }.not_to change(Evaluation, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include(
                                           "Score must be less than or equal to 10",
                                           "Comment is too short (minimum is 10 characters)"
                                         )
    end

    it "handles expired evaluation requests" do
      evaluation_request.update!(expires_at: 1.day.ago)

      evaluation_params = {
        evaluation: {
          score: 8,
          comment: "Excellent service, very professional and helpful.",
          token: evaluation_request.evaluation_token
        }
      }

      expect {
        post api_v1_evaluations_path, params: evaluation_params
      }.not_to change(Evaluation, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to include("Solicitação inválida ou expirada")
    end
  end
end