require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with valid input" do
      it "creates the review" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        post :create, review: { content: "Good film", rating: 4 }, video_id: video.id
        video.reviews.count.should == 1
      end
      it "redirects to video path" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        post :create, review: { content: "Good film", rating: 4 }, video_id: video.id        
        response.should redirect_to video_path(video)
      end
    end

    context "with invalid inputs" do
      let(:video) { video = Fabricate(:video) }

      before :each do
        user = Fabricate(:user)
        session[:user_id] = user.id
        post :create, review: { rating: 4 }, video_id: video.id
      end
      it "does not create a user" do
        video.reviews.count.should == 0
      end
      it "renders the new template" do
        response.should render_template 'videos/show'
      end
    end
  end

end