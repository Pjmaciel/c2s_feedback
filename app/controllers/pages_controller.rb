# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :about, :contact]

  def home
  end

  def about
  end

  def contact
  end

  def dashboard
  end

end
