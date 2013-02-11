require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets the @queue_items variable" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)

      get :index
      assigns(:queue_items).should == [queue_item1, queue_item2]
    end
    it "renders the Index template" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      get :index
      response.should render_template :index
    end
  end

  describe "POST create" do
    context "with valid input" do
      it "creates the queue_item" do
        user = Fabricate(:user)
        session[:user_id] = user.id       
        video = Fabricate(:video)
        post :create, video_id: video.id        
        user.queue_items.map(&:video).should == [video]
      end
      it "redirects to my_queue path" do
        user = Fabricate(:user)
        session[:user_id] = user.id       
        video = Fabricate(:video)
        post :create, video_id: video.id          
        response.should redirect_to my_queue_path
      end
    end
  end


  describe "DELETE destroy"
    it "deletes the queue item" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item1.id
      user.queue_items.should be_empty
    end

    it "renders the my_queue path" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item1.id
      response.should redirect_to my_queue_path
    end
end 