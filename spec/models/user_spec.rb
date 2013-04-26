require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews) }
  it { should have_many(:payments) }
  it { should have_many(:queue_items) }
  it { should have_many(:videos).through(:queue_items) }

  it { should have_many(:followed_relationships).with_foreign_key("follower_id").dependent(:destroy) }
  it { should have_many(:followed_users).through(:followed_relationships) }

  it { should have_many(:follower_relationships).with_foreign_key("followed_id").class_name("Relationship").dependent(:destroy) }
  it { should have_many(:followers).through(:follower_relationships) }

  describe "#has_video_in_queue?" do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }

    it "returns true if the queue does contain video" do
      user.queue_items.create(video: video)
      user.should have_video_in_queue(video)
    end

    it "returns false if the queue does not contain video" do
      user.should_not have_video_in_queue(video)
    end
  end

  describe "following and unfollowing" do
    let(:user) { Fabricate(:user) }
    let(:other_user) { Fabricate(:user) }

    before do
      user.follow!(other_user)
    end

    it "#follow! other_user" do
      user.followed_users.should include(other_user)
    end

    it "#follow! dosen't follow oneself" do
      user.follow!(user)
      user.followed_users.should_not include(user)
    end

    it "#follow! dosen't create duplicate relationships" do
      user.follow!(other_user)
      user.followed_users.count.should == 1
    end

    it { other_user.followers.should include(user) }

    it "#unfollow! other_user" do
      user.unfollow!(other_user)
      user.followed_users.should_not include(other_user)
    end

    it "#following?" do
      user.following?(other_user).should be_true
      user3 = Fabricate(:user)
      user.following?(user3).should be_false
    end

  end
end