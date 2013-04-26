class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      if user.active
        session[:user_id] = user.id
        redirect_to home_path, notice: "You have logged in."
      else
        flash[:error] = "Your user is no longer active."
        render :new
      end
    else
      flash[:error] = "Incorrect username or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have been logged out."
  end

end