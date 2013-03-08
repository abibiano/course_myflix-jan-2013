class PasswordResetsController < ApplicationController
  def create
    user = User.where(email: params[:email]).first
    user.send_password_reset if user.present?
    redirect_to reset_password_confimation_path
  end

  def edit
    @user = User.where(password_reset_token: params[:id]).first
    redirect_to forgot_password_path unless @user.present?
  end

  def update
    @user = User.where(password_reset_token: params[:id]).first
    if @user.present?
      if @user.password_reset_sent_at < 2.hours.ago
        redirect_to forgot_password_path, :alert => "Password reset has expired."
      elsif @user.update_attributes(params[:user])
        redirect_to sign_in_path, :notice => "Password has been reset!"
      else
        render :edit
      end
    else
      redirect_to forgot_password_path
    end
  end

end
