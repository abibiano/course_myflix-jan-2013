require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets the @video variable" do
      batman = Video.create(title: "Batman", description: "BAT!!")
      get :show, id: batman.id
      assigns(:video).should == batman
    end
    it "renders the show template" do
      get :show
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