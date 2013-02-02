require "spec_helper"

describe Category do
	it { should have_many(:videos) }
	it { should validate_presence_of(:name) }

	describe "recent_videos" do
		it "returns an empty array when no videos in category" do
			category_comedies = Category.create(name: 'TV Comedies')
			category_comedies.recent_videos.should == []
		end
		it "returns one video in category" do
			category_comedies = Category.create(name: 'TV Comedies')
			video1 = Video.create(title: "Video 1", description: "Description Video 1", category: category_comedies)
			category_comedies.recent_videos.should == [video1]
		end
		it "returns multiple videos in category in reverse chronically order" do
			category_comedies = Category.create(name: 'TV Comedies')
			video1 = Video.create(title: "Video 1", description: "Description Video 1", category: category_comedies, created_at: 1.day.ago)
			video2 = Video.create(title: "Video 2", description: "Description Video 2", category: category_comedies)

			category_comedies.recent_videos.should == [video2, video1]
		end

		it "returns up to 6 when there are more in category" do
			category_comedies = Category.create(name: 'TV Comedies')
			last_video = Video.create(title: "Last video", description: "Description last video", category: category_comedies)

			10.times do |number|
				Video.create(title: "Video #{number}", description: "Description Video #{1}", category: category_comedies, created_at: 1.day.ago)
			end

			category_comedies.recent_videos.size.should == 6
			category_comedies.recent_videos.first.should == last_video
		end
	end
end