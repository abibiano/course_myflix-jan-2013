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
      before :each do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "creates the user" do       
        User.count.should == 1
      end
      it "redirects to home path" do
        response.should redirect_to home_path
      end
    end

    context "with invalid inputs" do
      before :each do
        post :create, user: Fabricate.attributes_for(:user, full_name: nil)
      end
      it "does not create a user" do
        User.count.should == 0
      end
      it "renders the new template" do
        response.should render_template :new
      end
    end
  end
end