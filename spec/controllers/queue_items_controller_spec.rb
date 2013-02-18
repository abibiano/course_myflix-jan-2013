require 'spec_helper'

describe QueueItemsController do
  context "user is authenticated" do
    before { set_current_user }
    describe "GET #index" do

      it "sets the @queue_items variable" do
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        get :index
        expect(assigns(:queue_items)).to match_array [queue_item1, queue_item2]
      end

      it "renders the index template" do
        get :index
        expect(response).to  render_template :index
      end
    end

    describe "POST #create" do
      context "with valid input" do
        let(:video) { Fabricate(:video) }

        it "creates the queue_item" do
          post :create, video_id: video.id
          expect(current_user.queue_items.map(&:video)).to match_array [video]
        end

        it "redirects to my_queue path" do
          post :create, video_id: video.id
          expect(response).to redirect_to my_queue_path
        end
      end
    end

    describe "DELETE #destroy" do
      context "authorized user" do
        let(:queue_item1) { Fabricate(:queue_item, user: current_user) }
        let(:queue_item2) { Fabricate(:queue_item, user: current_user) }

        it "deletes the queue item" do
          delete :destroy, id: queue_item1.id
          expect(current_user.queue_items).to match_array [queue_item2]
        end

        it "redirects to my_queue path" do
          delete :destroy, id: queue_item1.id
          expect(response).to redirect_to my_queue_path
        end
      end

      context "unathorized user" do
        let(:user2) { Fabricate(:user) }
        let!(:queue_item1) { Fabricate(:queue_item, user: user2) }
        let(:queue_item2) { Fabricate(:queue_item, user: current_user) }

        it "does not delete the queue item" do
          expect {
            delete :destroy, id: queue_item1.id
          }.to_not change(user2.queue_items, :count)
        end

        it "redirects to the my queue page" do
          delete :destroy, id: queue_item1.id
          expect(response).to redirect_to my_queue_path
        end
      end
    end

    describe "PUT #update_multiple" do
      let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 2) }
      let(:queue_item3) { Fabricate(:queue_item, user: current_user, position: 3) }

      it "positions if more than one is changed" do
        put :update_multiple, queue_items: {queue_item1.id => {position: 2}, queue_item2.id => {position: 1}}
        expect(current_user.queue_items.reload).to eq [queue_item2, queue_item1]
        expect(current_user.queue_items.reload.map(&:position)).to eq [1, 2]
      end

      it "handles arbitraty position numbers and reorder them" do
        put :update_multiple, queue_items: {queue_item1.id => {position: 4}, queue_item2.id => {position: 2}, queue_item3.id => {position: 3}}
        expect(current_user.queue_items.reload).to eq [queue_item2, queue_item3, queue_item1]
        expect(current_user.queue_items.reload.map(&:position)).to eq [1, 2, 3]
      end

      it "handle decimal numbers" do
        put :update_multiple, queue_items: {queue_item1.id => {position: 2.5}, queue_item2.id => {position: 2}, queue_item3.id => {position: 3}}
        expect(current_user.queue_items.reload).to eq [queue_item2, queue_item1, queue_item3]
        expect(current_user.queue_items.reload.map(&:position)).to eq [1, 2, 3]
      end

      context "with rating" do
        context "with no prior rating" do
          context "no existing review" do

            it "does not create a review when does not select rating " do
              expect {
                put :update_multiple, queue_items: {queue_item1.id => {position: 2.5, rating: ""}, queue_item2.id => {position: 2, rating: ""}, queue_item3.id => {position: 3, rating: ""}}
              }.to_not change(Review, :count)
            end

            it "redirects to the my queue path" do
              put :update_multiple, queue_items: {queue_item1.id => {position: 2.5, rating: ""}, queue_item2.id => {position: 2, rating: ""}, queue_item3.id => {position: 3, rating: ""}}
              response.should redirect_to my_queue_path
            end
          end

          context "with existing review" do
            let!(:review) { Fabricate(:review, user: current_user, video: queue_item1.video, rating: 2) }

            it "updates and existing review" do
              put :update_multiple, queue_items: {queue_item1.id => {position: 2, rating: 3}, queue_item2.id => {position: 2, rating: ""}, queue_item3.id => {position: 3, rating: ""}}
              expect(review.reload.rating).to eq  3
            end

            it "clears an existing review's rating" do
              put :update_multiple, queue_items: {queue_item1.id => {position: 2, rating: ""}, queue_item2.id => {position: 2, rating: ""}, queue_item3.id => {position: 3, rating: ""}}
              expect(review.reload.rating).to be_nil
            end
          end
        end
      end
    end
  end
  context "user is not authenticated" do
    describe "GET #index" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :index }
      end
    end
    describe "POST #create" do
      video = Fabricate(:video)
      it_behaves_like "require_sign_in" do
        let(:action) { post :create, video_id: video.id }
      end
    end
    describe "DELETE #destroy" do
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user)
      it_behaves_like "require_sign_in" do
        let(:action) { delete :destroy, id: queue_item.id }
      end
    end
    describe "PUT #update_multiple" do
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, position: 1)
      it_behaves_like "require_sign_in" do
        let(:action) { put :update_multiple, queue_items: {queue_item.id => {position: 2}} }
      end
    end
  end
end