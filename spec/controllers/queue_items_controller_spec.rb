require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets the @queue_items variable" do
      user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
      session[:user_id] = user_alex.id
      video_batman = Video.create(title: "Batman", description: "BAT!!")
      video_superman = Video.create(title: "Superman", description: "Kryptonite")
      queue_item1 = user_alex.queue_items.create(video: video_batman)
      queue_item2 = user_alex.queue_items.create(video: video_superman)      
      get :index
      assigns(:queue_items).should =~ [queue_item1, queue_item2]
    end
    it "renders the Index template" do
      user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
      session[:user_id] = user_alex.id
      video_batman = Video.create(title: "Batman", description: "BAT!!")
      video_superman = Video.create(title: "Superman", description: "Kryptonite")
      queue_item1 = user_alex.queue_items.create(video: video_batman)
      queue_item2 = user_alex.queue_items.create(video: video_superman)      
      get :index
      response.should render_template :index
    end
  end

  describe "POST create" do
    context "with valid input" do
      it "creates the queue_item" do
        user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
        session[:user_id] = user_alex.id
        video_batman = Video.create(title: "Batman", description: "BAT!!")

        post :create, video_id: video_batman.id
        user_alex.queue_items.count.should == 1
      end
      it "redirects to my_queue path" do
        user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex")
        session[:user_id] = user_alex.id
        video_batman = Video.create(title: "Batman", description: "BAT!!")

        post :create, video_id: video_batman.id
        response.should redirect_to my_queue_path
      end
    end

  end
end