require 'spec_helper'

describe InvitationsController do
  context "user is authenticated" do
    before { set_current_user }

    describe "GET #new" do
      it "sets the @invitation variable" do
        get :new
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end
      it "renders the new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "with valid inputs" do

        it "creates the invitation" do
          expect {
            post :create, invitation: Fabricate.attributes_for(:invitation)
          }.to change(Invitation, :count).by(1)
        end

        it "redirects to the home path" do
          post :create, invitation: Fabricate.attributes_for(:invitation)
          expect(response).to redirect_to home_path
        end

        context "sends the invitation email" do
          before { reset_email }
          it "sends out the mail" do
            post :create, invitation: Fabricate.attributes_for(:invitation)
            expect(ActionMailer::Base.deliveries).to_not be_empty
          end
          it "sends to the right recipient"
          it "has the link with the token to register"
       end

      end
      context "with invalid inputs" do
        it "re-renders the new template" do
          post :create, invitation: Fabricate.attributes_for(:invitation, friend_email: nil)
          expect(response).to render_template :new
        end

        it "does not create the invitation" do
          expect {
            post :create, invitation: Fabricate.attributes_for(:invitation, friend_email: nil)
          }.to_not change(Invitation, :count)
        end
      end
    end
  end


  context "user is not authenticated" do
    describe "GET #new" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :new }
      end
    end

    describe "POST #create" do
      let(:invitations) { Fabricate(:invitation) }
      it_behaves_like "require_sign_in" do
        let(:action) { post :create, invitation: Fabricate.attributes_for(:invitation) }
      end
    end
  end
end