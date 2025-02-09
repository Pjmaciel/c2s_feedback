module Attendant
  class EvaluationRequestsController < BaseController
    def new
      @evaluation_request = EvaluationRequest.new
      @clients = User.where(role: 'client')
    end

    def create
      @evaluation_request = EvaluationRequest.new(evaluation_request_params)
      @evaluation_request.attendant = current_user
      @evaluation_request.expires_at = 24.hours.from_now

      if @evaluation_request.save
        redirect_to attendant_dashboard_path, notice: 'Solicitação de avaliação enviada com sucesso.'
      else
        @clients = User.where(role: 'client')
        render :new
      end
    end

    private

    def evaluation_request_params
      params.require(:evaluation_request).permit(:client_id)
    end
  end
end
