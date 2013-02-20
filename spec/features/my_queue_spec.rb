require 'spec_helper'

feature 'user interacts with the queue' do

  given(:joe) { Fabricate(:user) }
  given(:monk) { Fabricate(:video, title: 'Monk', description: "SF detective") }
  given(:futurama) { Fabricate(:video, title: 'Futurama') }
  given(:family_guy) { Fabricate(:video, title: 'Family Guy') }

  scenario 'adding and reordering videos in the queue' do
    sign_in(joe)

    add_video_to_queue(monk)

    page.should have_content "Monk"
    click_link("Monk")

    page.should have_content "Monk"
    page.should have_content "SF detective"
    page.should_not have_content "+ My Queue"

    add_video_to_queue(futurama)
    add_video_to_queue(family_guy)

    set_position(family_guy, 3)
    set_position(futurama, 1)
    set_position(monk, 2)

    click_button 'Update Instant Queue'

    page.find(:xpath, "//tr[contains(.,'Futurama')]//input")['value'].should == '1'
    page.find(:xpath, "//tr[contains(.,'Monk')]//input")['value'].should == '2'
    page.find(:xpath, "//tr[contains(.,'Family Guy')]//input")['value'].should == '3'
  end
end

def add_video_to_queue(video)
  visit home_path
  find("section.content a[href='#{video_path(video)}']").click
  click_link("+ My Queue")
end

def set_position(video, position)
  video_id = page.find(:xpath, "//tr[contains(.,'#{video.title}')]//input")['id']
  fill_in video_id, with: position.to_s
end