class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :gon_user, unless: :devise_controller?
  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: "text/html" }
      format.html { redirect_to root_url, alert: exception.message }
      format.js   { head :forbidden, content_type: "text/html" }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.current_user = current_user
  end
end
