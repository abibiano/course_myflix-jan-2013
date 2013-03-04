require 'spec_helper'

describe UsersController do
  context "user is not authenticated" do
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

      context "email sending" do
        it "sends out the email" do
          post :create, user: Fabricate.attributes_for(:user)
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end
        it "sends to the right recipient" do
          alice = Fabricate.attributes_for(:user)
          post :create, user: alice
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq [alice[:email]]
        end
        it "has the right content" do
          alice = Fabricate.attributes_for(:user, full_name: "Alice")
          post :create, user: alice
          message = ActionMailer::Base.deliveries.last
          expect(message.html_part.body).to include("Alice")
        end
      end
    end
    describe "GET #show" do
      let(:user) { Fabricate(:user) }
      it_behaves_like "require_sign_in" do
        let(:action) { get :show, id: user.id }
      end
    end
    describe "GET #people" do
      let(:user) { Fabricate(:user) }
      it_behaves_like "require_sign_in" do
        let(:action) { get :people, id: user.id }
      end
    end


  end
  context "user is authenticated" do
    before { set_current_user }
    describe "GET #show" do
      let(:user) { Fabricate(:user) }
      it "sets the @user variable" do
        get :show, id: user.id
        expect(assigns(:user)).to eq user
      end
      it "renders the show template" do
        get :show, id: user.id
        expect(response).to render_template :show
      end
    end
    describe "GET #people" do
      it "sets the @user variable" do
        get :people
        expect(assigns(:user)).to eq current_user
      end
      it "renders the people template" do
        get :people
        expect(response).to render_template :people
      end
    end
  end
end