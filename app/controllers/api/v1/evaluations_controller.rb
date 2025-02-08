# frozen_string_literal: true

module Api
  module V1
    class EvaluationsController < ApplicationController
      before_action :set_evaluation, only: [:show, :update, :destroy]

      def index
        @evaluations = policy_scope(Evaluation)
        render json: @evaluations
      end

      def show
        authorize @evaluation
        render json: @evaluation
      end

      def create
        @evaluation = Evaluation.new(evaluation_params)
        @evaluation.client = current_user
        authorize @evaluation

        if @evaluation.save
          render json: @evaluation, status: :created
        else
          render json: { errors: @evaluation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @evaluation

        if @evaluation.update(evaluation_params)
          render json: @evaluation
        else
          render json: { errors: @evaluation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @evaluation
        @evaluation.destroy
        head :no_content
      end

      private

      def set_evaluation
        @evaluation = Evaluation.find(params[:id])
      end

      def evaluation_params
        params.require(:evaluation).permit(:attendant_id, :score, :comment, :evaluation_date)
      end
    end
  end
end
