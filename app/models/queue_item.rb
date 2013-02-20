class QueueItem < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true
  validates :position, presence: true

  def rating
    review.rating if review
  end

  def rating=(number)
    if review
      number.blank? ? review.rating = nil : review.rating = number
      review.save(validate: false)
    else
      Review.new(user: user, video: video, rating: number).save(validate: false) unless number.blank?
    end
  end

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end

end