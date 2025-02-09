# frozen_string_literal: true

module Client
  class EvaluationsController < BaseController
    before_action :authenticate_user!
    before_action :ensure_client!

    before_action :set_evaluation, only: [:show, :edit, :update]


    def index
      @evaluations = current_user.evaluations.order(created_at: :desc)
    end

    def show; end

    def new
      @evaluation_request = EvaluationRequest.find_by(evaluation_token: params[:token], client: current_user)

      unless @evaluation_request&.pending?
        redirect_to root_path, alert: "Solicitação inválida ou expirada."
        return
      end

      @evaluation = current_user.evaluations.build(attendant: @evaluation_request.attendant)
    end


    def create
      @evaluation_request = EvaluationRequest.find_by(evaluation_token: params[:token], client: current_user)

      unless @evaluation_request&.pending?
        redirect_to root_path, alert: "Solicitação inválida ou expirada."
        return
      end

      @evaluation = current_user.evaluations.build(evaluation_params.merge(attendant: @evaluation_request.attendant))

      if @evaluation.save
        @evaluation_request.update(status: :completed)
        redirect_to client_dashboard_path, notice: "Avaliação registrada com sucesso!"
      else
        render :new
      end
    end

    def edit
      @evaluation = Evaluation.find(params[:id])
    end


    def update
      @evaluation = Evaluation.find(params[:id])
      if @evaluation.update(evaluation_params)
        redirect_to @evaluation, notice: 'Avaliação atualizada com sucesso.'
      else
        render :edit
      end
    end

    def destroy
      @evaluation = current_user.evaluations.find(params[:id])

      if @evaluation.created_at > 24.hours.ago
        @evaluation.destroy
        redirect_to client_dashboard_path, notice: "Avaliação excluída com sucesso."
      else
        redirect_to client_dashboard_path, alert: "Avaliação não pode ser excluída após 24 horas."
      end
    end

    def update
      @evaluation = current_user.evaluations.find(params[:id])

      if @evaluation.created_at > 24.hours.ago
        if @evaluation.update(evaluation_params)
          redirect_to client_dashboard_path, notice: 'Avaliação atualizada com sucesso.'
        else
          render :edit
        end
      else
        redirect_to client_dashboard_path, alert: "A avaliação só pode ser editada dentro de 24 horas após a criação."
      end
    end


    def ensure_client!
      unless current_user.client?
        redirect_to root_path, alert: "Apenas clientes podem acessar esta página."
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
