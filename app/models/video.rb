class Video < ActiveRecord::Base
	belongs_to :category

	validates :title, presence: true
	validates :description, presence: true

  has_many :reviews, order: "created_at DESC"
  has_many :queue_items
  has_many :users, :through => :queue_items

	def self.search_by_title(search_term)
    if search_term.blank?
      []
    else
		  where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
    end
	end

  def average_rating
    reviews.average(:rating).to_f.round(1)
  end

  def in_my_queue?(user)
    queue_items.exists?(user_id: user.id)
  end
end