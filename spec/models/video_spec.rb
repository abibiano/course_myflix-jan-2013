require 'spec_helper'

describe Video do
	it { should belong_to(:category) }
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }
	it { should have_many(:reviews) }
	it { should have_many(:queue_items) }
	it { should have_many(:users).through(:queue_items) }

	describe "search_by_title" do
		it "returns an empty array if there's no match" do
			batman = Video.create(title: "Batman", description: "BAT!!")
			Video.search_by_title("Spiderman").should == []
		end
		it "returns results if there is match" do
			batman = Video.create(title: "Batman", description: "BAT!!")
			superman = Video.create(title: "Superman", description: "Clark")
			Video.search_by_title("Batman").should == [batman]
		end

		it "the results should be in descending order of created_at" do
			batman = Video.create(title: "Batman", description: "BAT!!", created_at: 1.day.ago)
			superman = Video.create(title: "Superman", description: "Clark")
			Video.search_by_title("man").should == [superman, batman]
		end

		it "returns an empty array if the search term is blank" do
			superman = Video.create(title: "Superman", description: "Clark")
			Video.search_by_title("").should == []
		end
	end

	it "returns multiple reviews for a video in reverse chronically order" do
			superman = Video.create(title: "Superman", description: "Clark")
			user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
			user_chris = User.create(email: "chris@example.com", password: "1234", full_name: "Chris")

			review1 = superman.reviews.create(content: "Review 1", rating: 1, user: user_alex, created_at: 1.day.ago)
			review2 = superman.reviews.create(content: "Review 2", rating: 4, user: user_chris)

			superman.reviews.should == [review2, review1]
	end

	describe "average_rating" do
		it "returns 0 if there is no rating" do
			superman = Video.create(title: "Superman", description: "Clark")
			user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")

			superman.average_rating.should == 0
		end
		it "return the average of the review ratings rounded to 1 decimal" do
			superman = Video.create(title: "Superman", description: "Clark")
			user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
			user_chris = User.create(email: "chris@example.com", password: "1234", full_name: "Chris")			
			user_peter = User.create(email: "peter@example.com", password: "1234", full_name: "Peter")						

			review1 = superman.reviews.create(content: "Review 1", rating: 1, user: user_alex, created_at: 1.day.ago)
			review2 = superman.reviews.create(content: "Review 2", rating: 1, user: user_chris)
			review3 = superman.reviews.create(content: "Review 2", rating: 3, user: user_peter)

			superman.average_rating.should == 1.7
		end
	end

	describe "in_my_queue?" do
		it "returns false if video don't are in current user queue" do
			superman = Video.create(title: "Superman", description: "Clark")
			user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
    	superman.in_my_queue?(user_alex).should be_false

		end
		it "returns true if video don't are in current user queue" do
			superman = Video.create(title: "Superman", description: "Clark")
			user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
			user_alex.queue_items.create(video: superman)
    	superman.in_my_queue?(user_alex).should be_true
    end
	end

end