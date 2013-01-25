class Video < ActiveRecord::Base
	attr_accessible :title, :description, :small_cover_url, :large_cover_url

	belongs_to :category
	
end