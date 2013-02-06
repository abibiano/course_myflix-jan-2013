require 'spec_helper'

describe Video do
	it { should belong_to(:category) }
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }
	it { should have_many(:reviews) }

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
end