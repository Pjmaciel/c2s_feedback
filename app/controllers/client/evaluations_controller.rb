# frozen_string_literal: true

module Client
  class EvaluationsController < BaseController
    before_action :set_evaluation, only: [:show, :edit, :update, :destroy]

    def index
      @evaluations = current_user.evaluations.order(created_at: :desc)
    end

    def show; end

    def new
      @evaluation = current_user.evaluations.build
      @attendants = User.attendants
    end

    def create
      @evaluation = current_user.evaluations.build(evaluation_params)

      if @evaluation.save
        redirect_to [:client, @evaluation], notice: 'Avaliação criada.'
      else
        @attendants = User.attendants
        render :new
      end
    end

    private

    def set_evaluation
      @evaluation = current_user.evaluations.find(params[:id])
    end

    def evaluation_params
      params.require(:evaluation).permit(:attendant_id, :score, :comment, :evaluation_date)
    end
  end
end
