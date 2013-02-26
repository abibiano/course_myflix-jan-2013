require 'spec_helper'

describe SessionsController do
  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "valid email and password" do
      let(:user) { Fabricate(:user) }
      it "store user id in the session" do
        post :create, {email: user.email, password: user.password}
        expect(session[:user_id]).to eq(user.id)
      end
      it "redirects to home path" do
        post :create, {email: user.email, password: user.password}
        expect(response).to redirect_to home_path
      end
    end

    context "invalid email or password" do
      let(:user) { Fabricate(:user) }

      it "does not sets user id in the session" do
        post :create, {email: user.email, password: "false"}
        expect(session[:user_id]).to be_nil
      end
      it "renders the new template" do
        post :create, {email: user.email, password: "false"}
        expect(response).to render_template :new
      end
    end
  end

  describe "GET destroy" do
    it "sets sessions user_id to nil" do
      get :destroy
      expect(session[:user_id]).to be_nil
    end
    it "redirects to root_path" do
      get :destroy
      expect(response).to redirect_to root_path
    end
  end
end