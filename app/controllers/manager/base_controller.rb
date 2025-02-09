module Manager
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_manager!

    private

    def ensure_manager!
      unless current_user&.manager?
        redirect_to root_path, alert: 'Acesso não autorizado.'
      end
    end
  end
end