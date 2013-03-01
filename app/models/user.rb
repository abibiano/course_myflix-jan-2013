class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true
  validates :full_name, presence: true
  validates :password, presence: { on: :create }
  validates :email, uniqueness: true

  has_many :reviews
  has_many :videos, through: :queue_items
  has_many :queue_items, order: "position ASC"

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships

  def has_video_in_queue?(video)
    queue_items.map(&:video).include?(video)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.where("followed_id = ?", other_user.id).first.destroy
  end

  def following?(other_user)
    relationships.where("followed_id = ?", other_user.id).first
  end
end