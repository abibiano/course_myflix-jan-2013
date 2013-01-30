require "spec_helper"

describe Category do
	it { should have_many(:videos) }
	it { should validate_presence_of(:name) }

	describe "#recent_videos" do
		it "returns 1 video if there are only one" do
			category_commedies = Category.create(name: 'TV Commedies')
			video1 = Video.create(title: "Video 1", description: "Description Video 1", category: category_commedies)
			category_commedies.recent_videos.should =~ [video1]
		end
		it "returns 6 videos if there are more than 6" do
			category_commedies = Category.create(name: 'TV Commedies')
			1.upto(10) do |number|
				Video.create(title: "Video #{number}", description: "Description Video #{1}", category: category_commedies)
			end
			category_commedies.recent_videos.count.should == 6
		end
		it "reuturns videos sorted from newest to oldest" do
			category_commedies = Category.create(name: 'TV Commedies')
			video1 = Video.create(title: "Video 1", description: "Description Video 1", category: category_commedies)
			video2 = Video.create(title: "Video 2", description: "Description Video 2", category: category_commedies)
			video3 = Video.create(title: "Video 3", description: "Description Video 3", category: category_commedies)

			recent_videos = category_commedies.recent_videos
			recent_videos[0].should == video3
			recent_videos[1].should == video2
			recent_videos[2].should == video1
		end
	end
end