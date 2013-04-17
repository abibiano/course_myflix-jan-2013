class UserRegistration
  attr_accessor :user, :token

  def initialize(user, token)
    @user = user
    @token = token
  end

  def register_user
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :card => token,
        :description => user.email)
      if charge.successful?
        if @user.save
          AppMailer.delay.welcome_email(user)
          invitation = Invitation.where(friend_email: user.email).first
          handle_invitation(invitation) if invitation
        else
          "Error on saving user"
        end
      else
        charge.error_message
      end
    else
      "Invalid user"
    end
  end

  private

  def handle_invitation(invitation)
    user.follow! invitation.user
    invitation.user.follow! user
    invitation.update_attribute(:token, nil)
  end
end