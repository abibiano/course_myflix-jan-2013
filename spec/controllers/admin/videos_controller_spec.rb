require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    context "admins" do
      let(:alice) { Fabricate(:admin) }
      before { set_current_user(alice) }
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
        set_current_user(Fabricate(:user))
        get :new
        response.should redirect_to home_path
      end
    end
  end
  describe "POST create" do
    context "non admin"
    context "admins" do

      before { set_current_user(Fabricate(:admin)) }

      it "creates the video" do
        drama = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: drama.id, description: "Awesome series!" }
        monk = Video.find_by_title("Monk").should be_present
      end

      it "puts the video in the right category" do
        drama = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: drama.id, description: "Awesome series!" }
        monk = Video.find_by_title("Monk")
        monk.category.should == drama
      end

      it "redirects to the home path" do
        drama = Fabricate(:category)
        post :create, video: { title: "Monk", category_id: drama.id, description: "Awesome series!" }
        response.should redirect_to home_path
      end

      it "render :new for invalid video input" do
        drama = Fabricate(:category)
        post :create, video: { category_id: drama.id, description: "Awesome series!" }
        response.should render_template :new
      end
    end
  end
end