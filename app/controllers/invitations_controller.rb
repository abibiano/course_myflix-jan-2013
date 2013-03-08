class InvitationsController < ApplicationController
  before_filter :require_user, only: [:new, :create]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.user = current_user
    if @invitation.save
      AppMailer.invitation_email(@invitation).deliver
      redirect_to home_path, notice: 'Invitation was succesfully sent'
    else
      render :new
    end
  end
end