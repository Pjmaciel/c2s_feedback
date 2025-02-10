module Api
  module V1
    class EvaluationsController < ApplicationController
      include ActionController::MimeResponds
      skip_before_action :verify_authenticity_token
      before_action :set_evaluation_request, only: [:create]


      def create
        @evaluation = Evaluation.new(evaluation_params)
        @evaluation.client = @evaluation_request.client
        @evaluation.attendant = @evaluation_request.attendant
        @evaluation.evaluation_date = Time.current

        authorize @evaluation

        ActiveRecord::Base.transaction do
          if @evaluation.save
            @evaluation_request.update!(status: :completed)
            render json: {
              message: "Avaliação registrada com sucesso!",
              evaluation: @evaluation
            }, status: :created
          else
            render json: { errors: @evaluation.errors.full_messages },
                   status: :unprocessable_entity
          end
        end
      end

      def index
        @evaluations = policy_scope(Evaluation)
                         .includes(:attendant, :client)
                         .order(evaluation_date: :desc)

        @evaluations = @evaluations.where(sentiment: params[:sentiment]) if params[:sentiment].present?

        render json: serialize_evaluations(@evaluations), status: :ok
      end



      def filter
        @evaluations = EvaluationFilter.new(
          policy_scope(Evaluation).includes(:attendant, :client),
          filter_params
        ).filter

        render json: {
          evaluations: serialize_evaluations(@evaluations),
          meta: {
            total_pages: @evaluations.total_pages,
            current_page: @evaluations.current_page,
            total_count: @evaluations.total_count
          }
        }
      end


      private

      def serialize_evaluations(evaluations)
        evaluations.map do |evaluation|
          {
            id: evaluation.id,
            score: evaluation.score,
            comment: evaluation.comment,
            evaluation_date: evaluation.evaluation_date,
            sentiment: evaluation.sentiment, # ✅ Agora retorna o sentimento da avaliação
            attendant: {
              id: evaluation.attendant.id,
              name: evaluation.attendant.name,
              registration_number: evaluation.attendant.attendant_profile&.registration_number
            },
            client: {
              id: evaluation.client.id,
              name: evaluation.client.name
            }
          }
        end
      end


      def set_evaluation_request
        @evaluation_request = EvaluationRequest.includes(:client, :attendant)
                                               .find_by(evaluation_token: params[:token])

        if !@evaluation_request&.pending?
          render json: { error: "Solicitação inválida ou expirada" },
                 status: :unprocessable_entity
          return
        end

        unless @evaluation_request.client == current_user
          render json: { error: "Não autorizado" },
                 status: :unauthorized
        end
      end

      def generate_csv(evaluations)
        headers = ['Data', 'Atendente', 'Cliente', 'Nota', 'Comentário']

        CSV.generate(headers: true) do |csv|
          csv << headers

          evaluations.each do |evaluation|
            csv << [
              evaluation.evaluation_date.strftime("%d/%m/%Y"),
              evaluation.attendant.name,
              evaluation.client.name,
              evaluation.score,
              evaluation.comment
            ]
          end
        end
      end

      def filter_params
        params.permit(:attendant_id, :date_range, :score, :page, :per_page, :sentiment)
      end

      def evaluation_params
        params.require(:evaluation).permit(:score, :comment)
      end
    end
  end
end