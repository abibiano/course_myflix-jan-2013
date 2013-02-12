require 'spec_helper'

describe QueueItem do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:position) }



  describe "#review_rate" do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    let(:queue_item) { queue_item = user.queue_items.create(video: video) }

    subject { queue_item.review_rate }

    context "no user review" do
      it { should == 5 }
    end

    context "one user review" do
      before do
        review = video.reviews.create(content: "Review 1", rating: 1, user: user, created_at: 1.day.ago)
      end
      it { should == 1 }
    end
  end

end