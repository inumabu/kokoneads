class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_authentication
    return if logged_in?

    session[:return_to] = request.fullpath
    redirect_to login_path, alert: "保存機能を使うにはログインしてください。"
  end
end
