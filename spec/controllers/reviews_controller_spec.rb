require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with valid input" do
      it "creates the review" do
        userAlex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
        session[:user_id] = userAlex.id
        video_batman = Video.create(title: "Batman", description: "BAT!!")

        post :create, review: { content: "Good film", rating: 4 }, video_id: video_batman.id
        video_batman.reviews.count.should == 1
      end
      it "redirects to video path" do
        userAlex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
        session[:user_id] = userAlex.id
        video_batman = Video.create(title: "Batman", description: "BAT!!")

        post :create, review: { content: "Good film", rating: 4 }, video_id: video_batman.id
        response.should redirect_to video_path(video_batman)
      end
    end

    context "with invalid inputs" do
      it "does not create a user" do
        userAlex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
        session[:user_id] = userAlex.id
        video_batman = Video.create(title: "Batman", description: "BAT!!")

        post :create, review: { rating: 4 }, video_id: video_batman.id
        video_batman.reviews.count.should == 0
      end
      it "renders the new template" do
        userAlex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
        session[:user_id] = userAlex.id
        video_batman = Video.create(title: "Batman", description: "BAT!!")
        post :create, review: { rating: 4 }, video_id: video_batman.id

        response.should render_template 'videos/show'
      end
    end
  end
end