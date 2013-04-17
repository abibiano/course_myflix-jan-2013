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
    token = params[:stripeToken]
    error_message = UserRegistration.new(@user, token).register_user
    if error_message
      flash[:error] = error_message
      render :new
    else
      flash[:success] = "Thank you for your payment."
      session[:user_id] = @user.id
      redirect_to home_path, notice: 'User was succesfully created'
    end
  end


  def show
    @user = User.find(params[:id])
  end

  def people
    @user = current_user
  end



end