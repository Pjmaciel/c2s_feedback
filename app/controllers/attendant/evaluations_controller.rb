# frozen_string_literal: true

module Attendant
  class EvaluationsController < BaseController
    def index
      @evaluations = current_user.received_evaluations
                                 .includes(:client)
                                 .order(created_at: :desc)
                                 .page(params[:page])
    end

    def show
      @evaluation = current_user.received_evaluations.find(params[:id])
    end
  end
end
