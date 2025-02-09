module Manager
  class DashboardController < BaseController
    def index
      @total_evaluations = Evaluation.count
      @average_score = Evaluation.average(:score)&.round(2)
      @recent_evaluations = Evaluation.includes(:attendant, :client)
                                      .order(created_at: :desc)
                                      .limit(5)
      @total_attendants = User.where(role: 'attendant').count
      @total_clients = User.where(role: 'client').count
    end
  end
end