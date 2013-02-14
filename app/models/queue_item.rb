class QueueItem < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true
  validates :position, presence: true


  def review_rate
    review = video.reviews.where(user_id: user_id).first
    review.nil? ? 5 : review.rating
  end

  def self.save_multiple(queue_items)
    queue_items.each do |queue_item_hash|
      queue_item = QueueItem.find(queue_item_hash[0])
      queue_item.position = queue_item_hash[1][:position]
      queue_item.save
      update_or_create_review_rate(queue_item, queue_item_hash[1][:review_rate])
    end
  end

  private

  def self.update_or_create_review_rate(queue_item, review_rate)
    review = queue_item.video.reviews.where(user_id: queue_item.user_id).first
    if review.nil?
      review = Review.new(user: queue_item.user, video: queue_item.video, rating: review_rate)
      review.save(validate: false)
    else
      review.rating = review_rate
      review.save
    end
  end

end