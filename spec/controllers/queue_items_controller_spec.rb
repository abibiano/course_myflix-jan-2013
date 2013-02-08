require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    before :each do
      @user = Fabricate(:user)
      session[:user_id] = @user.id
      @video1 = Fabricate(:video)
      @video2 = Fabricate(:video)        
      @queue_item1 = @user.queue_items.create(video: @video1)
      @queue_item2 = @user.queue_items.create(video: @video2)      
      get :index
    end
    it "sets the @queue_items variable" do
      assigns(:queue_items).should =~ [@queue_item1, @queue_item2]
    end
    it "renders the Index template" do
      response.should render_template :index
    end
  end

  describe "POST create" do
    context "with valid input" do
      before :each do
        @user = Fabricate(:user)
        session[:user_id] = @user.id       
        @video = Fabricate(:video)

        post :create, video_id: @video.id
      end
      it "creates the queue_item" do
        @user.queue_items.count.should == 1
      end
      it "redirects to my_queue path" do
        response.should redirect_to my_queue_path
      end
    end
  end
end