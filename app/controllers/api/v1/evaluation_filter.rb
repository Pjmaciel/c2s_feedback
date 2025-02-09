# frozen_string_literal: true

module Api
  module V1
    class EvaluationFilter
      attr_reader :evaluations, :params

      def initialize(evaluations, params)
        @evaluations = evaluations
        @params = params
      end

      def filter
        scope = evaluations
        scope = filter_by_attendant(scope)
        scope = filter_by_date_range(scope)
        scope = filter_by_score(scope)
        scope = apply_pagination(scope)
        scope
      end

      private

      def filter_by_attendant(scope)
        return scope unless params[:attendant_id].present?
        scope.where(attendant_id: params[:attendant_id])
      end

      def filter_by_date_range(scope)
        return scope unless params[:date_range].present?

        range = case params[:date_range]
                when 'today'
                  Time.current.beginning_of_day..Time.current.end_of_day
                when 'week'
                  Time.current.beginning_of_week..Time.current.end_of_week
                when 'month'
                  Time.current.beginning_of_month..Time.current.end_of_month
                when 'year'
                  Time.current.beginning_of_year..Time.current.end_of_year
                else
                  return scope
                end

        scope.where(evaluation_date: range)
      end

      def filter_by_score(scope)
        return scope unless params[:score].present?
        scope.where(score: params[:score])
      end

      def apply_pagination(scope)
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 10).to_i
        scope.page(page).per(per_page)
      end
    end
  end
end
