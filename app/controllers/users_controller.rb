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
    if @user.save
      invitation = Invitation.where(friend_email: @user.email).first
      handle_invitation(invitation) if invitation
      AppMailer.delay.welcome_email(@user)
      session[:user_id] = @user.id
      redirect_to home_path, notice: 'User was succesfully created'
    else
      render :new
    end
  end


  def show
    @user = User.find(params[:id])
  end

  def people
    @user = current_user
  end

  private

  def handle_invitation(invitation)
    @user.follow! invitation.user
    invitation.user.follow! @user
    invitation.update_attribute(:token, nil)
  end

end