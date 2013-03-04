class PasswordResetsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    render :confirm
  end

  def edit
    @user = User.where(password_reset_token: params[:id]).first
  end

  def update
    @user = User.where(password_reset_token: params[:id]).first
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end

  def new
    @email = ""
  end
end
