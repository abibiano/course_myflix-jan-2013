require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }
  it { should have_many(:videos).through(:queue_items) }

  it { should have_many(:relationships).with_foreign_key("follower_id").dependent(:destroy) }
  it { should have_many(:followed_users).through(:relationships) }

  it { should have_many(:reverse_relationships).with_foreign_key("followed_id").class_name("Relationship").dependent(:destroy) }
  it { should have_many(:followers).through(:reverse_relationships) }

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



end