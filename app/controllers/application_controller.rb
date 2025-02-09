class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  before_action :store_user_location!, if: :storable_location?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def storable_location?
    request.get? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
  def user_not_authorized
    flash[:alert] = "Você não tem permissão para realizar esta ação."
    redirect_back(fallback_location: root_path)
  end

end
