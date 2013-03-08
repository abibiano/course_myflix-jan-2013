require 'spec_helper'

describe PasswordResetsController do

  describe "GET edit" do
    it "redenrs the edit template if token exists" do
      alice = Fabricate(:user, password: 'old_password', password_reset_token: 'abcd', password_reset_sent_at: Time.zone.now)
      get :edit, id: alice.password_reset_token
      response.should render_template :edit
    end
    it "redirects to the forgot password page it token not exists" do
      get :edit, id: "abcd"
      response.should redirect_to forgot_password_path
    end
  end

  describe "GET new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "with valid email" do
      after do
        ActionMailer::Base.deliveries = []
      end

      it "sends out an email to the email provided" do
        user = Fabricate(:user, email: 'joe@example.com' )
        post :create, email: 'joe@example.com'
        ActionMailer::Base.deliveries.should_not be_empty
      end
      it "redirects to password reset confirmation" do
        post :create, email: 'joe@example.com'
        response.should redirect_to reset_password_confimation_path
      end
    end
    context "with email not in system" do
      it "does not send out emails" do
        post :create, email: 'joe@example.com'
        ActionMailer::Base.deliveries.should be_empty
      end
      it "redirects to password reset confirmation" do
        post :create, email: 'joe@example.com'
        response.should redirect_to reset_password_confimation_path
      end
    end
  end

  describe "PUT update" do
    context "with valid token" do
      it "updates the user's password" do
        alice = Fabricate(:user, password: 'old_password', password_reset_token: 'abcd', password_reset_sent_at: Time.zone.now)
        put :update, id: alice.password_reset_token, user: { password: "new_password", password_confirmation: "new_password" }
        alice.reload.authenticate("new_password").should be_true
      end

      it "redirect to the sign in path" do
        alice = Fabricate(:user, password: 'old_password', password_reset_token: 'abcd', password_reset_sent_at: Time.zone.now)
        put :update, id: alice.password_reset_token, user: { password: "new_password", password_confirmation: "new_password" }
        response.should redirect_to sign_in_path
      end
    end

    context "with invalid token" do
      it "redirects to the forgot password page" do
        put :update, id: "abcd", user: { password: "new_password", password_confirmation: "new_password" }
        response.should redirect_to forgot_password_path
      end
      it "does not update any users password" do
        alice = Fabricate(:user, password: 'old_password', password_reset_token: 'abcd', password_reset_sent_at: Time.zone.now)
        put :update, id: "kkk", user: { password: "new_password", password_confirmation: "new_password" }
        alice.reload.authenticate("old_password").should be_true
      end
    end

    context "with expired token" do
      it "redirect to the forgot password page" do
        alice = Fabricate(:user, password: 'old_password', password_reset_token: 'abcd', password_reset_sent_at: 3.hours.ago)
        put :update, id: alice.password_reset_token, user: { password: "new_password", password_confirmation: "new_password" }
        response.should redirect_to forgot_password_path
      end
      it "does not update users password" do
        alice = Fabricate(:user, password: 'old_password', password_reset_token: 'abcd', password_reset_sent_at: 3.hours.ago)
        put :update, id: alice.password_reset_token, user: { password: "new_password", password_confirmation: "new_password" }
        alice.reload.authenticate("old_password").should be_true
      end
    end
  end

end
