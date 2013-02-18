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
    let(:user) { Fabricate(:user) }
    let(:queue_item1) { queue_item1 = Fabricate(:queue_item, user: user, position: 1) }
    let(:queue_item2) { queue_item2 = Fabricate(:queue_item, user: user, position: 2) }
    let(:queue_item3) { queue_item3 = Fabricate(:queue_item, user: user, position: 3) }

    before do
      session[:user_id] = user.id
    end

    it "updates multiple queue_items position if more than one item is changed" do
      put :update_multiple, queue_items: {queue_item1.id => {position: 2}, queue_item2.id => {position: 1}}
      user.queue_items.reload.should == [queue_item2, queue_item1]
      user.queue_items.reload.map(&:position).should == [1, 2]
    end
    it "handles arbitraty position numbers and reorder them" do
      put :update_multiple, queue_items: {queue_item1.id => {position: 4}, queue_item2.id => {position: 2}, queue_item3.id => {position: 3}}
      user.queue_items.reload.should == [queue_item2, queue_item3, queue_item1]
      user.queue_items.reload.map(&:position).should == [1, 2, 3]
    end
    it "handle decimal numbers" do
      put :update_multiple, queue_items: {queue_item1.id => {position: 2.5}, queue_item2.id => {position: 2}, queue_item3.id => {position: 3}}
      user.queue_items.reload.should == [queue_item2, queue_item1, queue_item3]
      user.queue_items.reload.map(&:position)== [1, 2, 3]
    end

    context "with rating" do
      context "with no prior rating" do
        context "no existing review" do
          it "does not create a review when does not select rating " do
            put :update_multiple, queue_items: {queue_item1.id => {position: 2.5, rating: ""}, queue_item2.id => {position: 2, rating: ""}, queue_item3.id => {position: 3, rating: ""}}
            Review.count.should == 0
          end

          it "redirects to the my queue path" do
            put :update_multiple, queue_items: {queue_item1.id => {position: 2.5, rating: ""}, queue_item2.id => {position: 2, rating: ""}, queue_item3.id => {position: 3, rating: ""}}
            response.should redirect_to my_queue_path
          end
        end

        context "with existing review" do
          it "updates and existing review" do
            review = Fabricate(:review, user: user, video: queue_item1.video, rating: 2)
            put :update_multiple, queue_items: {queue_item1.id => {position: 2, rating: 3}, queue_item2.id => {position: 2, rating: ""}, queue_item3.id => {position: 3, rating: ""}}
            review.reload.rating.should == 3
          end

          it "clears an existing review's rating" do
            review = Fabricate(:review, user: user, video: queue_item1.video, rating: 2)
            put :update_multiple, queue_items: {queue_item1.id => {position: 2, rating: ""}, queue_item2.id => {position: 2, rating: ""}, queue_item3.id => {position: 3, rating: ""}}
            review.reload.rating.should == nil
          end
        end
      end
    end
  end
end