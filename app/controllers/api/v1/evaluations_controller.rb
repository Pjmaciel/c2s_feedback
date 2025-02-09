# frozen_string_literal: true

module Api
  module V1
    class EvaluationsController < ApplicationController
      before_action :set_evaluation_request, only: [:create]

      def index
        @evaluations = policy_scope(Evaluation)
        render json: @evaluations
      end

      def show
        @evaluation = Evaluation.find(params[:id])
        authorize @evaluation
        render json: @evaluation
      end

      def create
        @evaluation = Evaluation.new(evaluation_params)
        @evaluation.client = @evaluation_request.client
        @evaluation.attendant = @evaluation_request.attendant
        authorize @evaluation

        if @evaluation.save
          @evaluation_request.update(status: :completed)
          render json: { message: "Avaliação registrada com sucesso!", evaluation: @evaluation }, status: :created
        else
          render json: { errors: @evaluation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @evaluation = Evaluation.find(params[:id])
        authorize @evaluation

        if @evaluation.update(evaluation_params)
          render json: @evaluation
        else
          render json: { errors: @evaluation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @evaluation = Evaluation.find(params[:id])
        authorize @evaluation
        @evaluation.destroy
        head :no_content
      end

      private

      def set_evaluation_request
        @evaluation_request = EvaluationRequest.find_by(evaluation_token: params[:token])
        unless @evaluation_request&.pending?
          render json: { error: "Solicitação inválida ou expirada" }, status: :unprocessable_entity
        end
      end

      def evaluation_params
        params.require(:evaluation).permit(:attendant_id, :score, :comment, :evaluation_date)
      end
    end
  end
end

