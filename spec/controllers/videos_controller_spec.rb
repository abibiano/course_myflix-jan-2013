require 'spec_helper'

describe VideosController do
  before :each do
    user = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
    session[:user_id] = user.id
  end
  describe "GET show" do
    it "sets the @video variable" do
      batman = Video.create(title: "Batman", description: "BAT!!")
      get :show, id: batman.id
      assigns(:video).should == batman
    end
    it "renders the show template" do
      batman = Video.create(title: "Batman", description: "BAT!!")
      get :show, id: batman.id
      response.should render_template :show
    end
  end

  describe "POST search" do
    it "sets the @videos variable" do
      superman = Video.create(title: "Superman", description: "Clark")
      post :search, search_term: "superman"
      assigns(:videos).should == [superman]
    end
    it "renders the search template" do
      post :search
      response.should render_template :search
    end
  end
end