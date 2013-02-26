require "spec_helper"

describe Category do
	it { should have_many(:videos) }
	it { should validate_presence_of(:name) }

	describe "#recent_videos" do
		let(:category) { Fabricate(:category) }

		it "returns an empty array when no videos in category" do
			expect(category.recent_videos).to be_empty
		end
		it "returns one video in category" do
			video = Fabricate(:video, category: category)
			expect(category.recent_videos).to match_array([video])
		end
		it "returns multiple videos in category in reverse chronically order" do
			video1 = Fabricate(:video, category: category, created_at: 1.day.ago)
			video2 = Fabricate(:video, category: category)

			expect(category.recent_videos).to eq([video2, video1])
		end

		it "returns up to 6 when there are more in category" do
			last_video = Fabricate(:video, category: category)

			10.times do |number|
				Fabricate(:video, category: category, created_at: 1.day.ago)
			end

			expect(category.recent_videos.size).to eq(6)
			expect(category.recent_videos.first).to eq(last_video)
		end
	end
end