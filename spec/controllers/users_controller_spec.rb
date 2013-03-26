require 'spec_helper'

describe UsersController do
  context "user is not authenticated" do
    describe "GET #new" do
      context "invitation token is nil" do
        it "sets the @user variable" do
          get :new
          expect(assigns(:user)).to be_a_new(User)
        end
        it "renders the new template" do
          get :new
          expect(response).to render_template :new
        end
      end
    end
    context "invitation token is used" do
      it "sets email and username is invitation token exists" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, user: alice, friend_email: "bob@example.com", friend_full_name: "Bob")
        get :new, id: invitation.token
        expect(assigns(:user)).to be_a_new(User)
        expect(assigns(:user).email).to eq "bob@example.com"
        expect(assigns(:user).full_name).to eq "Bob"
      end
      it "dose not sets email and username if token exists" do
        alice = Fabricate(:user)
        get :new, id: "1234"
        expect(assigns(:user)).to be_a_new(User)
        expect(assigns(:user).email).to be_nil
        expect(assigns(:user).full_name).to be_nil
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
        it "create relationship if invitation exists" do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, user: alice, friend_email: "bob@example.com", friend_full_name: "Bob")
          post :create, user: Fabricate.attributes_for(:user, email: "bob@example.com", full_name: "Bob")
          expect(User.last.following? alice).to be_true
          expect(alice.following? User.last).to be_true
        end
        it "does not create relationship if invitation dosent exists" do
          expect {
            post :create, user: Fabricate.attributes_for(:user)
          }.to_not change(Relationship, :count)
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

      context "sends the welcome email" do
        before { reset_email }
        it "sends out the email" do
          post :create, user: Fabricate.attributes_for(:user)
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end
        it "sends to the right recipient" do
          alice = Fabricate.attributes_for(:user)
          post :create, user: alice
          expect(last_email.to).to eq [alice[:email]]
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
    before { set_current_user(Fabricate(:user)) }
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