require 'spec_helper'

describe ReviewsController do
  context "user is authenticated" do
    before { set_current_user(Fabricate(:user)) }
    describe "POST #create" do
      context "with valid input" do
        let(:video) { Fabricate(:video) }
        it "creates the review" do
          expect{
            post :create, review: { content: "Good film", rating: 4 }, video_id: video.id
          }.to change(video.reviews, :count).by(1)
        end
        it "redirects to video path" do
          post :create, review: { content: "Good film", rating: 4 }, video_id: video.id
          expect(response).to redirect_to video
        end
      end

      context "with invalid inputs" do
        let(:video) { video = Fabricate(:video) }
        it "does not create a user" do
          expect {
            post :create, review: { content: "", rating: 4 }, video_id: video.id
          }.to_not change(User, :count)
        end
        it "renders the new template" do
          post :create, review: { content: "", rating: 4 }, video_id: video.id
          expect(response).to render_template 'videos/show'
        end
      end
    end
  end
  context "user is not authenticated" do
    describe "POST #create" do
      let(:video) { Fabricate(:video) }
      it_behaves_like "require_sign_in" do
        let(:action) { post :create, review: { rating: 4 }, video_id: video.id }
      end
    end
  end
end