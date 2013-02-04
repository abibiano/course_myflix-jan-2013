require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template" do
      get :new
      response.should render_template :new
    end
  end
  describe "POST create" do
    it "creates the session user_id when the email and password is valid" do
      user = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
      post :create, {email: user.email, password: user.password}
      session[:user_id].should == user.id
    end
    it "redirects to home path when the email and password is valid" do
      user = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
      post :create, {email: user.email, password: user.password}
      response.should redirect_to home_path
    end

    it "does not sets the session user_id when the email or password is invalid" do
      user = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
      post :create, {email: user.email, password: "false"}
      session[:user_id].should == nil
    end
    it "renders the new template when the email or password is invalid" do
      user = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
      post :create, {email: user.email, password: "false"}
      response.should render_template :new
    end
  end

  describe "GET destroy" do
    it "sets sessions user_id to nil" do
      get :destroy
      session[:user_id].should == nil
    end
    it "redirects to root_path" do
      get :destroy
      response.should redirect_to root_path
    end
  end
end