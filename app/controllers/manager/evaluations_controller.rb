# frozen_string_literal: true

# frozen_string_literal: true

module Manager
  class EvaluationsController < BaseController
    before_action :set_evaluation, only: [:show]

    def index
      @evaluations = filter_evaluations
      @attendants = User.where(role: 'attendant')
    end

    def show
      authorize @evaluation
    end

    # 🔥 Novo método para processar a filtragem via rota /manager/evaluations/filter
    def filter
      @evaluations = filter_evaluations
      @attendants = User.where(role: 'attendant')

      respond_to do |format|
        format.html { render :index } # Renderiza a mesma view do index
        format.json { render json: @evaluations } # Retorna JSON se necessário
      end
    end

    private

    def set_evaluation
      @evaluation = Evaluation.find(params[:id])
    end

    def filter_evaluations
      evaluations = policy_scope(Evaluation).includes(:attendant, :client).order(evaluation_date: :desc)

      evaluations = evaluations.where(attendant_id: params[:attendant_id]) if params[:attendant_id].present?

      if params[:date_range].present?
        date_range = case params[:date_range]
                     when 'today'
                       Time.current.all_day
                     when 'week'
                       Time.current.all_week
                     when 'month'
                       Time.current.all_month
                     else
                       Time.current.all_year
                     end
        evaluations = evaluations.where(evaluation_date: date_range)
      end

      evaluations = evaluations.where(score: params[:score]) if params[:score].present?
      evaluations = evaluations.where(sentiment: params[:sentiment]) if params[:sentiment].present? && params[:sentiment] != ""

      evaluations
    end
  end
end
