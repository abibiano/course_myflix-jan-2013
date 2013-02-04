class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  protect_from_forgery

  def current_user
    User.find(session[:user_id]) if !session[:user_id].nil?
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      redirect_to sign_in_path, error: "You must be logged in."
    end
  end
end
