class QueueItem < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true
  validates :position, presence: true
  validates :position, :uniqueness => { :scope => :user_id }

  def review_rate
    review = video.reviews.where(user_id: user_id).first
    review.nil? ? 5 : review.rating
  end

end