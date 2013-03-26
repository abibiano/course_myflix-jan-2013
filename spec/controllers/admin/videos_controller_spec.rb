require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    context "admins" do
      let(:alice) { Fabricate(:admin) }
      before { session[:user_id] = alice.id }
      it "assigns @video as a new video" do
        get :new
        assigns(:video).should be_new_record
        assigns(:video).should be_instance_of(Video)
      end
      it "renders :new template" do
        get :new
        response.should render_template :new
      end
    end
    context "non admin" do
      it "redirects to sign in page if user is not signed in" do
        get :new
        response.should redirect_to sign_in_path
      end
      it "redirects to home page if user is not an admin" do
        set_current_user
        get :new
        response.should redirect_to home_path
      end
    end
  end

end