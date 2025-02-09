# frozen_string_literal: true

module Api
  module V1
    class EvaluationRequestsController < ApplicationController
      before_action :set_evaluation_request, only: [:show]

      def create
        @evaluation_request = EvaluationRequest.new(evaluation_request_params)
        @evaluation_request.attendant = current_user

        authorize @evaluation_request

        if @evaluation_request.save
          render json: @evaluation_request, status: :created
        else
          render json: { errors: @evaluation_request.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def show
        authorize @evaluation_request
        render json: @evaluation_request
      end

      private

      def set_evaluation_request
        @evaluation_request = EvaluationRequest.find_by!(evaluation_token: params[:token])
      end

      def evaluation_request_params
        params.require(:evaluation_request).permit(:client_id)
      end
    end
  end
end