module Api
  module V1
    class EvaluationsController < ApplicationController
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
            render json: {
              message: "Avaliação registrada com sucesso!",
              evaluation: @evaluation
            }, status: :created
          else
            render json: { errors: @evaluation.errors.full_messages },
                   status: :unprocessable_entity
          end
        end
      end

      private

      def set_evaluation_request
        @evaluation_request = EvaluationRequest.includes(:client, :attendant)
                                               .find_by(evaluation_token: params[:token])

        if !@evaluation_request&.pending?
          render json: { error: "Solicitação inválida ou expirada" },
                 status: :unprocessable_entity
          return
        end

        unless @evaluation_request.client == current_user
          render json: { error: "Não autorizado" },
                 status: :unauthorized
        end
      end

      def evaluation_params
        params.require(:evaluation).permit(:score, :comment)
      end
    end
  end
end