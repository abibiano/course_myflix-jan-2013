require 'spec_helper'

describe QueueItem do  
  it { should belong_to(:video) }
  it { should belong_to(:user) }

  describe "review_rate" do
    it "returns 5 if there's no review from the user" do
      video_superman = Video.create(title: "Superman", description: "Clark")
      user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
      queue_item1 = user_alex.queue_items.create(video: video_superman)      

      queue_item1.review_rate.should == 5
    end
    it "returns users reting" do
      video_superman = Video.create(title: "Superman", description: "Clark")
      user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")

      review1 = video_superman.reviews.create(content: "Review 1", rating: 1, user: user_alex, created_at: 1.day.ago)     

      queue_item1 = user_alex.queue_items.create(video: video_superman)      

      queue_item1.review_rate.should == 1
    end  
  end
end