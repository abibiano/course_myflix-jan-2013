require 'spec_helper'

describe Video do
	it { should belong_to(:category) }
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }

	describe "#search_by_title" do
		it "return empty array if no video is found" do
			batman = Video.create(title: "Batman", description: "BAT!!")
			superman = Video.create(title: "Superman", description: "Clark")
			south_park = Video.create(title: "South Park", description: "Famous for its crude language")
			Video.search_by_title("Spiderman").should be_empty
		end
		it "return one video if total match" do
			batman = Video.create(title: "Batman", description: "BAT!!")
			superman = Video.create(title: "Superman", description: "Clark")
			south_park = Video.create(title: "South Park", description: "Famous for its crude language")
			Video.search_by_title("Batman").should =~ [batman]
		end
		
		it "return an array of videos if partial match" do
			batman = Video.create(title: "Batman", description: "BAT!!")
			superman = Video.create(title: "Superman", description: "Clark")
			south_park = Video.create(title: "South Park", description: "Famous for its crude language")
			Video.search_by_title("man").should =~ [batman, superman]
		end

	end
end