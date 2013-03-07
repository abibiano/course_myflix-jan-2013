require 'spec_helper'

describe PasswordResetsController do

  describe "GET 'new'" do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end

    describe "POST create" do
      it "sends out an email to the email provided" do
        post :create, email: 'joe@example.com'
        ActionMailer::Base.deliveries.should_not be_empty
      end
      it "redirects to password reset confirmation"
    end
  end

end
