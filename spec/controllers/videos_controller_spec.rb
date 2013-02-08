require 'spec_helper'

describe VideosController do
  context "user is authenticated" do
    before :each do
      user = Fabricate(:user)
      session[:user_id] = user.id
    end
    describe "GET show" do
      let(:video) { video = Fabricate(:video) }
      it "sets the @video variable" do
        get :show, id: video.id
        assigns(:video).should == video
      end
      it "renders the show template" do
        get :show, id: video.id
        response.should render_template :show
      end
    end

    describe "POST search" do
      it "sets the @videos variable" do
        superman = Fabricate(:video, title: "Superman")
        post :search, search_term: "superman"
        assigns(:videos).should == [superman]
      end
      it "renders the search template" do
        post :search
        response.should render_template :search
      end
    end
  end
  context "user is not authenticated" do
    describe "GET show" do
      it "redirectos to sign in path" do
        video = Fabricate(:video)
        get :show, id: video.id
        response.should redirect_to sign_in_path
      end
    end
  end
end