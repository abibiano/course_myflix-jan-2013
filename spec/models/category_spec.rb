require "spec_helper"

describe Category do
	it "saves itself" do
		category = Category.new(name: "Commedies")
		category.save
		Category.first.name.should == "Commedies"
	end

	it "can have many videos" do
		category_commedies = Category.create(name: "Commedies")
		Video.create(title: 'Family Guy', \
			description: 'Family Guy is an American animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company. The series centers on the Griffins, a dysfunctional family consisting of parents Peter and Lois; their children Meg, Chris, and Stewie; and their anthropomorphic pet dog Brian. The show is set in the fictional city of Quahog, Rhode Island, and exhibits much of its humor in the form of cutaway gags that often lampoon American culture.', \
			small_cover_url: '/tmp/family_guy.jpg', \
			category: category_commedies)
		Video.create(title: 'Futurama', \
			description: 'Futurama is an American animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company. The series follows the adventures of a late-20th-century New York City pizza delivery boy, Philip J. Fry, who, after being unwittingly cryogenically frozen for one thousand years, finds employment at Planet Express, an interplanetary delivery company in the retro-futuristic 31st century. The series was envisioned by Groening in the late 1990s while working on The Simpsons, later bringing Cohen aboard to develop storylines and characters to pitch the show to Fox.', \
		 	small_cover_url: '/tmp/futurama.jpg', \
			category: category_commedies)
		Category.first.videos.count.should == 2
	end
end