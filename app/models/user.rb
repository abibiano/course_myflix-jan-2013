class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true
  validates :full_name, presence: true
  validates :password, presence: true

end