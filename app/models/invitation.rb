class Invitation < ActiveRecord::Base
  belongs_to :user

  before_create :generate_token

  validates :friend_email, presence: true
  validates :friend_full_name, presence: true

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

end