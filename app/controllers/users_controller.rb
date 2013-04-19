class UsersController < ApplicationController
  before_filter :require_user, only: [:show, :people]

  def new
    @user = User.new
    unless params[:id].nil?
      invitation = Invitation.where(token: params[:id]).first
      @user.email = invitation.friend_email if invitation
      @user.full_name = invitation.friend_full_name if invitation
    end
  end

  def create
    @user = User.new(params[:user])
    stripe_token = params[:stripeToken]
    result = UserRegistration.new(@user).register_user(stripe_token)
    handle_registration_result(result)
  end

  def show
    @user = User.find(params[:id])
  end

  def people
    @user = current_user
  end

  private

  def handle_registration_result(result)
    if result.invalid_user?
      render :new
    elsif result.successful?
      flash[:success] = "Thank you for your payment."
      session[:user_id] = @user.id
      redirect_to home_path, notice: 'User was succesfully created'
    else
      flash[:error] = result.stripe_error_message
      render :new
    end
  end


end