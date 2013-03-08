class InvitationsController < ApplicationController
  before_filter :require_user, only: [:new, :create]

  def new
    @invitation = Invitation.new
  end

  def create
    redirect_to home_path, notice: 'Invitation was succesfully sent'
  end
end