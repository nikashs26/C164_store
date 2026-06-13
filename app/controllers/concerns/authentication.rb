module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    flash[:alert] = "Please log in to continue."
    redirect_to login_path
  end

  def require_admin
    require_login
    return if current_user&.admin?

    flash[:alert] = "Admin access required."
    redirect_to root_path
  end
end
