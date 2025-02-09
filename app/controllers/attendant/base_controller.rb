# frozen_string_literal: true

module Attendant
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_attendant!

    private

    def ensure_attendant!
      unless current_user&.attendant?
        redirect_to root_path, alert: 'Acesso não autorizado.'
      end
    end
  end
end