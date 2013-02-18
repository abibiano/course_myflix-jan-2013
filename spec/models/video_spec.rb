require 'spec_helper'

describe Video do
	it { should belong_to(:category) }
	it { should have_many(:reviews).order("created_at DESC") }
	it { should have_many(:queue_items) }
	it { should have_many(:users).through(:queue_items) }
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }

	describe "#search_by_title" do
		let(:video_batman) { Fabricate(:video, title: "Batman") }
		let(:video_superman) { Fabricate(:video, title: "Superman", created_at: 1.day.ago ) }

		it "returns an empty array if there's no match" do
			expect(Video.search_by_title("Spiderman")).to be_empty
		end

		it "returns results if there is match" do
			expect(Video.search_by_title("Batman")).to match_array [video_batman]
		end

		it "the results should be in descending order of created_at" do
			expect(Video.search_by_title("man")).to eq [video_batman, video_superman]
		end

		it "returns an empty array if the search term is blank" do
			expect(Video.search_by_title("")).to be_empty
		end
	end

	describe "#average_rating" do
		let(:video) { Fabricate(:video) }
		let(:user)	{ Fabricate(:user) }

		it "returns 0 if there is no rating" do
			expect(video.average_rating).to eq(0)
		end
		it "return the average of the review ratings rounded to 1 decimal" do
			review1 = Fabricate(:review, rating: 1, video: video)
			review2 = Fabricate(:review, rating: 1, video: video)
			review3 = Fabricate(:review, rating: 3, video: video)

			expect(video.average_rating).to eq(1.7)
		end
	end

end