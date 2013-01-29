class Video < ActiveRecord::Base
	belongs_to :category

	validates :title, presence: true
	validates :description, presence: true
	
	def self.search_by_title(search_term)
		Video.where("title LIKE ?", "%#{search_term}%")
	end
end