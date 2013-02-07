class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :text, presence: true
  validates :rating, presence: true
  validates :rating, inclusion: 1..5
  validates :user_id, presence: true
  validates :video_id, presence: true
end