require 'spec_helper'

describe VideosController do
  context "user is authenticated" do
    before { set_current_user }
    describe "GET #show" do
      let(:video) { video = Fabricate(:video) }
      it "sets the @video variable" do
        get :show, id: video.id
        expect(assigns(:video)).to eq video
      end
      it "renders the show template" do
        get :show, id: video.id
        expect(response).to render_template :show
      end
    end

    describe "GET #home" do
      it "sets the @categories variable with all categories" do
        category = Fabricate(:category)
        get :home
        expect(assigns(:categories)).to match_array [category]
      end
      it "renders the home templeate" do
        get :home
        expect(response).to render_template :home
      end
    end

    describe "POST #search" do
      it "sets the @videos variable with" do
        superman = Fabricate(:video, title: "superman")
        post :search, search_term: "superman"
        expect(assigns(:videos)).to match_array [superman]
      end
      it "renders the search template" do
        post :search
        expect(response).to render_template :search
      end
    end
  end

  context "user is not authenticated" do
    describe "GET #show" do
      let(:video) { Fabricate(:video) }
      it_behaves_like "require_sign_in" do
        let(:action) { get :show, id: video.id }
      end
    end
    describe "GET #home" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :home }
      end
    end
    describe "POST #search" do
      it_behaves_like "require_sign_in" do
        let(:action) { post :search }
      end
    end
  end

end