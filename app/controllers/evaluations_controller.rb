
class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @evaluations = Evaluation.includes(:attendant, :client).order(evaluation_date: :desc)

    @evaluations = @evaluations.where(attendant_id: params[:attendant_id]) if params[:attendant_id].present?
    @evaluations = @evaluations.where(score: params[:score]) if params[:score].present?

    if params[:sentiment].present?
      Rails.logger.info "Aplicando filtro de sentimento: #{params[:sentiment]}"
      @evaluations = @evaluations.where(sentiment: params[:sentiment])
    end

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