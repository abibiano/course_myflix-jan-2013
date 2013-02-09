require 'spec_helper'

describe Video do
	it { should belong_to(:category) }
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }
	it { should have_many(:reviews).order("created_at DESC") }
	it { should have_many(:queue_items) }
	it { should have_many(:users).through(:queue_items) }

	describe "#search_by_title" do
		let(:video_batman) { Fabricate(:video, title: "Batman") }
		let(:video_superman) { Fabricate(:video, title: "Superman", created_at: 1.day.ago ) }

		it "returns an empty array if there's no match" do
			Video.search_by_title("Spiderman").should == []
		end
		it "returns results if there is match" do
			Video.search_by_title("Batman").should == [video_batman]
		end

		it "the results should be in descending order of created_at" do
			Video.search_by_title("man").should == [video_batman, video_superman]
		end

		it "returns an empty array if the search term is blank" do
			Video.search_by_title("").should == []
		end
	end

	describe "#average_rating" do
		let(:video) { Fabricate(:video) }
		let(:user)	{ Fabricate(:user) }

		it "returns 0 if there is no rating" do
			video.average_rating.should == 0
		end
		it "return the average of the review ratings rounded to 1 decimal" do
			user2 = Fabricate(:user)
			user3 = Fabricate(:user)

			review1 = video.reviews.create(content: "Review 1", rating: 1, user: user, created_at: 1.day.ago)
			review2 = video.reviews.create(content: "Review 2", rating: 1, user: user2)
			review3 = video.reviews.create(content: "Review 2", rating: 3, user: user3)

			video.average_rating.should == ((review1.rating + review2.rating + review3.rating) / 3.0).round(1)
		end
	end

	describe "#in_my_queue?" do
		let(:video) { Fabricate(:video) }
		let(:user)	{ Fabricate(:user) }

		it "returns false if video don't are in current user queue" do
    	video.in_my_queue?(user).should be_false
		end
		it "returns true if video don't are in current user queue" do
			user.queue_items.create(video: video)
    	video.in_my_queue?(user).should be_true
    end
	end

end