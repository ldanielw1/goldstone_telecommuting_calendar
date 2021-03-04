class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :require_login

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  ##
  # Force users to login if nobody is logged in via the session hash right now
  def require_login
    unless current_user
      redirect_to signin_path
    end
  end
end
