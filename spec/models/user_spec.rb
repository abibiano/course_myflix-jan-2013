require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }
  it { should have_many(:videos).through(:queue_items) }

  describe "#has_video_in_queue?" do
    let(:video) { video = Fabricate(:video) }
    let(:user) { user = Fabricate(:user) }

    it "returns true if the queue does contain video" do
      user.queue_items.create(video: video)
      user.should have_video_in_queue(video)
    end

    it "returns false if the queue does not contain video" do
      user.should_not have_video_in_queue(video)
    end
  end

  describe "#reorder_queue_items" do
    it "reorders queue items and assign possition starting with 1" do
      user = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: user, position: 2)
      queue_item3 = Fabricate(:queue_item, user: user, position: 1.5)
      user.reorder_queue_items
      user.queue_items.should == [queue_item1, queue_item3, queue_item2]
      user.queue_items[0].position.should == 1
      user.queue_items[1].position.should == 2
      user.queue_items[2].position.should == 3
    end
  end

end