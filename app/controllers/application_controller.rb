class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :gon_user, unless: :devise_controller?
  allow_browser versions: :modern

  private

  def gon_user
    gon.current_user = current_user
  end
end
