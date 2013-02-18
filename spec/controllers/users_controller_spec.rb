require 'spec_helper'

describe UsersController do
  describe "GET #new" do
    it "sets the @user variable" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
  end
  describe "POST #create" do
    context "with valid input" do
      it "creates the user" do
        expect {
          post :create, user: Fabricate.attributes_for(:user)
        }.to change(User, :count).by(1)
      end
      it "redirects to home path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid inputs" do
      it "does not create a user" do
        expect {
          post :create, user: Fabricate.attributes_for(:user, full_name: nil)
        }.to_not change(User, :count)
      end
      it "re-renders the new template" do
        post :create, user: Fabricate.attributes_for(:user, full_name: nil)
        expect(response).to render_template :new
      end
    end
  end
end