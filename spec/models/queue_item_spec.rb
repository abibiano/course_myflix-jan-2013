require 'spec_helper'

describe QueueItem do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:position) }

  describe "#rating" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }

    context "user has a review on the video" do
      it "pulls the rating from the user review" do
        review = Fabricate(:review, video: video, user: user, rating: 4)
        expect(queue_item.rating).to eq(4)
      end
    end
    context "user does not have review on the video" do
      it "returns nil" do
        expect(queue_item.rating).to be_nil
      end
    end
  end

  describe "#rating=" do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}
    let(:queue_item) {Fabricate(:queue_item, user: user, video: video)}
    it "sets the rating on the review if the review is present" do
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item.rating = 2
      expect(review.reload.rating).to eq(2)
    end

    it "creates a new review if there is no review for the video" do
      queue_item.rating = 2
      expect(user.reviews.first.rating).to eq(2)
    end
  end

  describe "#review" do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}
    let(:queue_item) {Fabricate(:queue_item, user: user, video: video)}
    it "returns the review if the review is present" do
      review = Fabricate(:review, video: video, user: user, rating: 4)
      expect(queue_item.review).to eq(review)
    end

    it "returns nil if there is no review for the video" do
      expect(queue_item.review).to be_nil
    end
  end

end