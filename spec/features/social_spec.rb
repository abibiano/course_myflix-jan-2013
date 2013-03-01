require 'spec_helper'

feature 'user interacts with the queue' do

  scenario 'following and unfollowing a user' do
    alex = Fabricate(:user)
    alice = Fabricate(:user)
    commedies = Fabricate(:category)
    monk = Fabricate(:video, title: 'Monk', description: "SF detective", category: commedies)
    review_alice = Fabricate(:review, user: alice, video: monk)

    sign_in(alex)
    visit video_path(monk)
    click_link(alice.full_name)
    click_button("Follow")
    click_link("People")
    page.should have_content alice.full_name
    page.find(:xpath, "//tr[contains(.,'#{alice.full_name}')]//td[4]/a").click
    page.should_not have_content alice.full_name
  end
end