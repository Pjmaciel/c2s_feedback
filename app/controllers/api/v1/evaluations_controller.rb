# app/controllers/api/v1/evaluations_controller.rb
module Api
  module V1
    class EvaluationsController < ApplicationController
      include ActionController::MimeResponds
      skip_before_action :verify_authenticity_token
      before_action :set_evaluation_request, only: [:create]

      def create
        @evaluation = Evaluation.new(evaluation_params)
        @evaluation.client = @evaluation_request.client
        @evaluation.attendant = @evaluation_request.attendant
        @evaluation.evaluation_date = Time.current

        authorize @evaluation

        ActiveRecord::Base.transaction do
          if @evaluation.save
            @evaluation_request.update!(status: :completed)

            # Enfileirar jobs de notificação
            EvaluationNotificationJob.perform_later(@evaluation.id)
            AttendantNotificationJob.perform_later(@evaluation.id)

            render json: {
              message: "Avaliação registrada com sucesso!",
              evaluation: serialize_evaluation(@evaluation)
            }, status: :created
          else
            render json: { errors: @evaluation.errors.full_messages },
                   status: :unprocessable_entity
          end
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def set_evaluation_request
        @evaluation_request = EvaluationRequest.includes(:client, :attendant)
                                               .find_by(evaluation_token: params[:token])

        if @evaluation_request.nil?
          render json: { error: "Solicitação não encontrada" }, status: :not_found
          return
        end

        unless @evaluation_request.client == current_user
          render json: { error: "Não autorizado" }, status: :unauthorized
          return
        end

        unless @evaluation_request.pending?
          render json: { error: "Solicitação inválida ou expirada" },
                 status: :unprocessable_entity
          return
        end
      end

      def serialize_evaluation(evaluation)
        {
          id: evaluation.id,
          score: evaluation.score,
          comment: evaluation.comment,
          evaluation_date: evaluation.evaluation_date,
          sentiment: evaluation.try(:sentiment),
          attendant: {
            id: evaluation.attendant.id,
            name: evaluation.attendant.name,
            registration_number: evaluation.attendant.attendant_profile&.registration_number
          },
          client: {
            id: evaluation.client.id,
            name: evaluation.client.name
          }
        }
      end

      def evaluation_params
        params.require(:evaluation).permit(:score, :comment)
      end
    end
  end
end