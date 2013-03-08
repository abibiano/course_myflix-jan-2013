require 'spec_helper'

describe RelationshipsController do
  context "user is authenticated" do
    before { set_current_user }

    describe "POST #create" do
      context "with valid input" do
        let(:user) { Fabricate(:user) }

        it "follows the user" do
          post :create, user_id: user.id
          expect(current_user.following?(user)).to be_true
        end

        it "redirects to user_path path" do
          post :create, user_id: user.id
          expect(response).to redirect_to user_path(user)
        end
      end
    end

    describe "DELETE #destroy" do
      let(:user) { Fabricate(:user) }

      it "unfollow the user" do
        current_user.follow!(user)
        delete :destroy, id: user.id
        expect(current_user.following?(user)).to be_false
      end

      it "redirects to people_path path" do
        current_user.follow!(user)
        delete :destroy, id: user.id
        expect(response).to redirect_to people_path
      end
    end
  end
  context "user is not authenticated" do
    describe "POST #create" do
      let(:user) { Fabricate(:user) }
      it_behaves_like "require_sign_in" do
        let(:action) { post :create, user_id: user.id }
      end
    end
    describe "DELETE #destroy" do
      let(:user) { Fabricate(:user) }
      it_behaves_like "require_sign_in" do
        let(:action) { delete :destroy, id: user.id }
      end
    end
  end
end