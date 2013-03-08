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

    describe "GET #post" do
      context "with valid inputs" do
        it "creates the invitation"
        it "sends the invitation to the friend's email"
        it "redirects to the home path"
      end
      context "with invalid inputs" do
        it "re-renders the new template"
        it "does not create the invitation"
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