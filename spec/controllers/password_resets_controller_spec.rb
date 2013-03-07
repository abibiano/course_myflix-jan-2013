require 'spec_helper'

describe PasswordResetsController do

  describe "GET 'new'" do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end

    describe "POST create" do
      context "with valid email" do
        after do
          ActionMailer::Base.deliveries == []
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
  end

end
