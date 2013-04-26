class PlansController < ApplicationController

  def index
    @user = current_user
  end

  def destroy
    @user = User.find(params[:id])
    response = StripeWrapper::Customer.cancel(stripe_id: @user.stripe_id)
    if response.successful?
      @user.active = false
      @user.save
      session[:user_id] = nil
      redirect_to root_path, notice: "Your suscription has been canceled."
    else
      flash[:error] = response.error_message
      render :index
    end
  end

end