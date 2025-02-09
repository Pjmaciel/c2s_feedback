class EvaluationReportJob
  include Sidekiq::Job

  def perform(user_id, report_params_json)
    user = User.find(user_id)
    report_params = JSON.parse(report_params_json)
    evaluations = filter_evaluations(report_params)

    report = {
      generated_at: Time.current,
      total_evaluations: evaluations.count,
      average_score: evaluations.average(:score)&.round(2),
      score_distribution: calculate_score_distribution(evaluations),
      attendant_performance: calculate_attendant_performance(evaluations)
    }

    Sidekiq.redis do |conn|
      conn.setex(
        "report:#{user_id}:#{Time.current.to_i}",
        1.day.to_i,
        report.to_json
      )
    end
  end

  private

  def filter_evaluations(params)
    evaluations = Evaluation.all

    if params['start_date'].present? && params['end_date'].present?
      evaluations = evaluations.where(
        evaluation_date: Date.parse(params['start_date'])..Date.parse(params['end_date'])
      )
    end

    if params['attendant_id'].present?
      evaluations = evaluations.where(attendant_id: params['attendant_id'])
    end

    evaluations
  end

  def calculate_score_distribution(evaluations)
    evaluations.group(:score).count
  end

  def calculate_attendant_performance(evaluations)
    evaluations
      .joins(:attendant)
      .group('users.name')
      .select(
        'users.name',
        'COUNT(*) as total_evaluations',
        'AVG(evaluations.score) as average_score'
      )
      .map { |result| [result.name, { total: result.total_evaluations, average: result.average_score.round(2) }] }
      .to_h
  end
end