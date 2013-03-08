class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true
  validates :full_name, presence: true
  validates :password, presence: { on: :create }
  validates :email, uniqueness: true

  has_many :reviews
  has_many :videos, through: :queue_items
  has_many :queue_items, order: "position ASC"

  has_many :followed_relationships, foreign_key: "follower_id",
                                    class_name: "Relationship",
                                    dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :followed

  has_many :follower_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :follower_relationships

  def has_video_in_queue?(video)
    queue_items.map(&:video).include?(video)
  end

  def follow!(other_user)
    followed_relationships.create!(followed_id: other_user.id) unless other_user == self || following?(other_user)
  end

  def unfollow!(other_user)
    followed_relationships.where("followed_id = ?", other_user.id).first.destroy
  end

  def following?(other_user)
    followed_relationships.where("followed_id = ?", other_user.id).any?
  end

  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!
    AppMailer.password_reset(self).deliver
  end

end