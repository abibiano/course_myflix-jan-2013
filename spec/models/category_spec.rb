require "spec_helper"

describe Category do
	it { should have_many(:videos) }
	it { should validate_presence_of(:name) }

	describe "#recent_videos" do
		let(:category) { Fabricate(:category) }

		it "returns an empty array when no videos in category" do
			category.recent_videos.should == []
		end
		it "returns one video in category" do
			video = Fabricate(:video, category: category)
			category.recent_videos.should == [video]
		end
		it "returns multiple videos in category in reverse chronically order" do
			video1 = Fabricate(:video, category: category, created_at: 1.day.ago)
			video2 = Fabricate(:video, category: category)

			category.recent_videos.should == [video2, video1]
		end

		it "returns up to 6 when there are more in category" do
			last_video = Fabricate(:video, category: category)

			10.times do |number|
				Fabricate(:video, category: category, created_at: 1.day.ago)
			end

			category.recent_videos.size.should == 6
			category.recent_videos.first.should == last_video
		end
	end
end