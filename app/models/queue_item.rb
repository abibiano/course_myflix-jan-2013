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

  def self.save_multiple(queue_items, user)
    queue_items.each do |queue_item_hash|
      queue_item = QueueItem.find(queue_item_hash[0])
      queue_item.attributes = queue_item_hash[1]
      queue_item.save
    end
  end

end