require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user variable" do
      get :new
      assigns(:user).should be_new_record
      assigns(:user).should be_instance_of(User)
    end
    it "renders the new template" do
      get :new
      response.should render_template :new
    end
  end
  describe "POST create" do
    it "creates the user record when the input is valid" do
      post :create, user: {email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano"}
      user = User.first
      user.email.should == "alex@bibiano.es"
      user.full_name.should == "Alex Bibiano"
      user.authenticate("1234").should == user
    end
    it "redirects to home path when input is valid" do
      post :create, user: {email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano"}
      response.should redirect_to home_path
    end

    it "does not create a user when the input is invalid" do
      post :create, user: {full_name: "Alex Bibiano"}
      User.count.should == 0
    end
    it "renders the new template when the input is invalid" do
      post :create, user: {full_name: "Alex Bibiano"}
      response.should render_template :new
    end
  end
end