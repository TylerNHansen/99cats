class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def login!(user)
    device_name = request.env["HTTP_USER_AGENT"]
    session[:token] = Session.make_session(user.id, device_name)
    @current_user = user
  end

  def current_user
    @current_user ||= Session.find_user(session[:token])
  end

  def logged_in?
    !!current_user
  end

  def logout
    Session.find_by_token(session[:token]).try(:destroy!)
    session[:token] = nil
  end
end
