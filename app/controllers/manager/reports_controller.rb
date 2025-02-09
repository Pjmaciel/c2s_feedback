# app/controllers/manager/reports_controller.rb
module Manager
  class ReportsController < BaseController
    def index
      @attendants = User.where(role: 'attendant')
      @recent_reports = fetch_recent_reports
    end

    def create
      report_data = {
        start_date: params.dig(:report, :start_date),
        end_date: params.dig(:report, :end_date),
        attendant_id: params.dig(:report, :attendant_id).presence
      }.compact

      EvaluationReportJob.perform_async(current_user.id, report_data.to_json)

      redirect_to manager_reports_path,
                  notice: 'Relatório está sendo gerado. Atualize a página em alguns instantes.'
    end

    private

    def fetch_recent_reports
      reports = []
      Sidekiq.redis do |conn|
        keys = conn.keys("report:#{current_user.id}:*")
        keys.each do |key|
          report_data = conn.get(key)
          reports << JSON.parse(report_data) if report_data
        end
      end
      reports.sort_by { |r| Time.parse(r['generated_at']) }.reverse
    end
  end
end