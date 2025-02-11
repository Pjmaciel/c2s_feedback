# frozen_string_literal: true

module Attendant
  class EvaluationsController < BaseController
    def index
      @evaluations = filter_evaluations
    end

    def show
      @evaluation = current_user.received_evaluations.find(params[:id])
    end

    def filter
      @evaluations = filter_evaluations

      respond_to do |format|
        format.html { render :index } # Renderiza a mesma view do index
        format.json { render json: @evaluations } # Retorna JSON se necessário
      end
    end

    private

    def filter_evaluations
      evaluations = current_user.received_evaluations.includes(:client).order(created_at: :desc)

      evaluations = evaluations.where(score: params[:score]) if params[:score].present?
      evaluations = evaluations.where(sentiment: params[:sentiment]) if params[:sentiment].present? && params[:sentiment] != ""

      evaluations
    end
  end
end
