class Invitation < ActiveRecord::Base
  belongs_to :user

  validates :friend_email, presence: true
  validates :friend_full_name, presence: true

end