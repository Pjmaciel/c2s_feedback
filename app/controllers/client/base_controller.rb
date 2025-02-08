# frozen_string_literal: true

module Client
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_client!

    private

    def ensure_client!
      unless current_user&.client?
        redirect_to root_path, alert: 'Acesso não autorizado.'
      end
    end
  end
end
