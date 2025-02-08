module Client
  class DashboardController < BaseController
    def index
      @recent_evaluations = current_user.evaluations.order(created_at: :desc).limit(5)
      @evaluation_count = current_user.evaluations.count
    end
  end
end