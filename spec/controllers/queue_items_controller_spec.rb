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
    context "authenticated and authorized user" do
        let(:user) { user = Fabricate(:user) }
        let(:queue_item1) { queue_item1 = Fabricate(:queue_item, user: user) }
        let(:queue_item2) { queue_item1 = Fabricate(:queue_item, user: user) }
      before do
        session[:user_id] = user.id
        delete :destroy, id: queue_item1.id
      end

      it "deletes the queue item" do
        user.queue_items.should == [queue_item2]
      end

      it "redirects to my_queue path" do
        response.should redirect_to my_queue_path
      end
    end

    context "unauthenticated user" do
      before do
        queue_item1 = Fabricate(:queue_item)
        delete :destroy, id: queue_item1.id
      end
      it "does not delete the queue item" do
        QueueItem.count.should == 1
      end

      it "redirects the user to the sign in page" do
        response.should redirect_to sign_in_path
      end
    end

    context "unathorized delete" do
      before do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user2.id
        queue_item1 = Fabricate(:queue_item, user: user1)
        delete :destroy, id: queue_item1.id
      end
      it "does not delete the queue item" do
        QueueItem.count.should == 1
      end
      it "redirects to the my queue page" do
        response.should redirect_to my_queue_path
      end
    end
  end

  describe "PUT update_multiple" do
    it "don't changes queue_item position if no position is changed" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      put :update_multiple, {}
      queue_item1.position.should == 1
    end
    it "updates multiple queue_items position if more than one item is changed" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: user, position: 2)
      put :update_multiple, queue_items: {queue_item1.id.to_s=>{"position"=>"3"}, queue_item2.id.to_s=>{"position"=>"2"}}
      user.queue_items.reload.should == [queue_item2, queue_item1]
    end
    it "updates multiple queue_items and sort recalculate position if any is decimal" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: user, position: 2)
      queue_item3 = Fabricate(:queue_item, user: user, position: 3)
      put :update_multiple, queue_items: {queue_item1.id.to_s=>{"position"=>"1"}, queue_item2.id.to_s=>{"position"=>"2"}, queue_item3.id.to_s=>{"position"=>"1.5"}}
      user.queue_items.reload.should == [queue_item1, queue_item3, queue_item2]
      user.queue_items.reload.map(&:position)== [1, 2, 3]
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