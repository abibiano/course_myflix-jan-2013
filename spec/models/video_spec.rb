require 'spec_helper'

describe Video do
	it "saves itself" do
		video = Video.new(title: 'Family Guy', \
			description: 'Family Guy is an American animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company. The series centers on the Griffins, a dysfunctional family consisting of parents Peter and Lois; their children Meg, Chris, and Stewie; and their anthropomorphic pet dog Brian. The show is set in the fictional city of Quahog, Rhode Island, and exhibits much of its humor in the form of cutaway gags that often lampoon American culture.')
		video.save
		Video.first.title.should == "Family Guy"
	end

	it "can belongs to a category" do
		category_commedies = Category.create(name: "Commedies")
		video = Video.new(title: 'Family Guy', \
			description: 'Family Guy is an American animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company. The series centers on the Griffins, a dysfunctional family consisting of parents Peter and Lois; their children Meg, Chris, and Stewie; and their anthropomorphic pet dog Brian. The show is set in the fictional city of Quahog, Rhode Island, and exhibits much of its humor in the form of cutaway gags that often lampoon American culture.', \
			category: category_commedies)
		video.save
		Video.first.category.should == category_commedies
	end

	it "is invalid without a title" do
		Video.new(title: nil).should_not be_valid
	end

	it "is invalid without a description" do
		Video.new(title: nil, description: "test description").should_not be_valid
	end

	it "is invalid without a description" do
		Video.new(title: "test title", description: nil).should_not be_valid
	end

	
end