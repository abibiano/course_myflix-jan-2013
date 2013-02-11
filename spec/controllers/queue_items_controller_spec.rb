require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets the @queue_items variable" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: user, position: 2)

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

      it "creates the queue item with the next avalaible position" do
        user = Fabricate(:user)
        session[:user_id] = user.id       
        video = Fabricate(:video)
        post :create, video_id: video.id        
        user.queue_items.first.position == 1
      end
    end
  end


  describe "DELETE destroy" do
    it "deletes the queue item" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      delete :destroy, id: queue_item1.id
      user.queue_items.should be_empty
    end

    it "redirects to my_queue path" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      delete :destroy, id: queue_item1.id
      response.should redirect_to my_queue_path
    end
  end

  describe "PUT update_multiple" do
    it "don't changes queue_item position if no position is changed" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      put :update_multiple, {}
      queue_item1.reload
      queue_item1.position.should == 1
    end     
    it "updates multiple queue_items position if more than one item is changed" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: user, position: 2)
      put :update_multiple, queue_items: {queue_item1.id.to_s=>{"position"=>"3"}, queue_item2.id.to_s=>{"position"=>"2"}}
      queue_item1.reload
      queue_item2.reload      
      queue_item1.position.should == 2
      queue_item2.position.should == 1    
    end
    it "updates multiple queue_items and sort recalculate position if any is decimal" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: user, position: 2)
      queue_item3 = Fabricate(:queue_item, user: user, position: 3)
      put :update_multiple, queue_items: {queue_item1.id.to_s=>{"position"=>"1"}, queue_item2.id.to_s=>{"position"=>"2"}, queue_item3.id.to_s=>{"position"=>"1.5"}}
      queue_item1.reload
      queue_item2.reload      
      queue_item3.reload      
      queue_item1.position.should == 1
      queue_item2.position.should == 3    
      queue_item3.position.should == 2
    end
    it "redirects to my_queu_path" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      put :update_multiple, {}
      response.should redirect_to my_queue_path
    end
  end
end 