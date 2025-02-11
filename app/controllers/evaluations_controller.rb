class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @evaluations = Evaluation.includes(:attendant, :client).order(evaluation_date: :desc)

    # Aplicação dos filtros na index
    @evaluations = apply_filters(@evaluations)

    render :index
  end

  # 🔥 Método de filtro separado
  def filter
    @evaluations = Evaluation.includes(:attendant, :client).order(evaluation_date: :desc)

    # Aplicação dos filtros
    @evaluations = apply_filters(@evaluations)

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @evaluations }
    end
  end

  def show
    authorize @evaluation
  end

  def new
    @evaluation = Evaluation.new
    @attendants = User.where(role: 'attendant')
    authorize @evaluation
  end

  def create
    @evaluation = Evaluation.new(evaluation_params)
    @evaluation.client = current_user
    authorize @evaluation

    if @evaluation.save
      redirect_to evaluations_path, notice: 'Avaliação criada com sucesso.'
    else
      @attendants = User.where(role: 'attendant')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def evaluation_params
    params.require(:evaluation).permit(:attendant_id, :score, :comment, :evaluation_date)
  end

  # 🔥 Método para aplicar os filtros dinamicamente
  def apply_filters(evaluations)
    evaluations = evaluations.where(attendant_id: params[:attendant_id]) if params[:attendant_id].present?
    evaluations = evaluations.where(score: params[:score]) if params[:score].present?
    evaluations = evaluations.where(sentiment: params[:sentiment]) if params[:sentiment].present? && params[:sentiment] != ""

    evaluations
  end
end
