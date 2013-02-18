require 'spec_helper'

describe QueueItem do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:position) }

  describe "#rating" do
    context "user has a review on the video" do
      it "pulls the rating from the user review" do
        user = Fabricate(:user)
        video = Fabricate(:video)
        review = Fabricate(:review, video: video, user: user, rating: 4)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rating.should == 4
      end
    end
    context "user does not have review on the video" do
      it "returns nil" do
        user = Fabricate(:user)
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rating.should == nil
      end
    end
  end

  describe "#rating" do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    let(:queue_item) { queue_item = user.queue_items.create(video: video) }

    subject { queue_item.rating }

    context "no user review" do
      it { should == nil }
    end

    context "one user review" do
      before do
        review = video.reviews.create(content: "Review 1", rating: 1, user: user, created_at: 1.day.ago)
      end
      it { should == 1 }
    end
  end

  describe "#rating=" do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}
    let(:queue_item) {Fabricate(:queue_item, user: user, video: video)}
    it "sets the rating on the review if the review is present" do
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item.rating = 2
      review.reload.rating.should == 2
    end

    it "creates a new review if there is no review for the video" do
      queue_item.rating = 2
      user.reviews.first.rating.should == 2
    end

  end

end