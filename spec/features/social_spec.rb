require 'spec_helper'

feature 'user interacts with the queue' do

  given(:alex) { Fabricate(:user) }
  given(:alice) { Fabricate(:user) }
  given(:commedies) { Fabricate(:category) }
  given(:monk) { Fabricate(:video, title: 'Monk', description: "SF detective", category: commedies) }
  given(:family_guy) { Fabricate(:video, title: "Family Guy") }

  background do
    Fabricate(:review, user: alice, video: monk)
  end

  scenario 'following and unfollowing a user' do
    sign_in(alex)
    visit video_path(monk)
    click_link alice.full_name
    click_button 'Follow'
    click_link 'People'
    page.should have_content alice.full_name
    page.find(:xpath, "//tr[contains(.,'#{alice.full_name}')]//td[4]/a").click
    page.should_not have_content alice.full_name
  end
end