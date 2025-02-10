
class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @evaluations = Evaluation.includes(:attendant, :client).order(evaluation_date: :desc)

    # Aplicando filtros
    @evaluations = @evaluations.where(attendant_id: params[:attendant_id]) if params[:attendant_id].present?
    @evaluations = @evaluations.where(score: params[:score]) if params[:score].present?

    # Filtro de sentimento ajustado
    if params[:sentiment].present? && params[:sentiment] != ''
      @evaluations = @evaluations.where(sentiment: params[:sentiment])
    end

    # Debug para verificar os parâmetros e a consulta SQL
    Rails.logger.info "Parâmetros recebidos: #{params}"
    Rails.logger.info "Consulta SQL gerada: #{@evaluations.to_sql}"

    render :index
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

  def edit
    authorize @evaluation
    @attendants = User.where(role: 'attendant')
  end

  def update
    authorize @evaluation
    if @evaluation.update(evaluation_params)
      redirect_to evaluations_path, notice: 'Avaliação atualizada com sucesso.'
    else
      @attendants = User.where(role: 'attendant')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @evaluation
    @evaluation.destroy
    redirect_to evaluations_path, notice: 'Avaliação excluída com sucesso.'
  end

  private

  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def evaluation_params
    params.require(:evaluation).permit(:attendant_id, :score, :comment, :evaluation_date)
  end
end