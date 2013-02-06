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
    context "with valid input" do
      it "creates the user" do
        post :create, user: {email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano"}
        user = User.first
        user.email.should == "alex@bibiano.es"
        user.full_name.should == "Alex Bibiano"
        user.authenticate("1234").should == user
      end
      it "redirects to home path" do
        post :create, user: {email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano"}
        response.should redirect_to home_path
      end
    end

    context "with invalid inputs" do
      it "does not create a user" do
        post :create, user: {full_name: "Alex Bibiano"}
        User.count.should == 0
      end
      it "renders the new template" do
        post :create, user: {full_name: "Alex Bibiano"}
        response.should render_template :new
      end
    end
  end
end