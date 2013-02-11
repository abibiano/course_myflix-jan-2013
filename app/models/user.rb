class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true
  validates :full_name, presence: true
  validates :password, presence: true
  validates :email, uniqueness: true

  has_many :reviews
  has_many :videos, :through => :queue_items
  has_many :queue_items, order: "position ASC"

  def has_video_in_queue?(video)
    queue_items.map(&:video).include?(video)
  end

end