require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST create" do
    context "valid email and password" do
      let(:user) { user = Fabricate(:user) }
      
      it "store user id in the session" do
        post :create, {email: user.email, password: user.password}
        session[:user_id].should == user.id
      end
      it "redirects to home path" do
        post :create, {email: user.email, password: user.password}
        response.should redirect_to home_path
      end
    end

    context "invalid email or password" do
      let(:user) { user = Fabricate(:user) }
      
      it "does not sets user id in the session" do       
        post :create, {email: user.email, password: "false"}
        session[:user_id].should be_nil
      end
      it "renders the new template" do
        post :create, {email: user.email, password: "false"}
        response.should render_template :new
      end
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