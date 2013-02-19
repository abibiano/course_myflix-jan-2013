require 'spec_helper'

feature 'User sign in' do
  background do
    category_commedies = Category.create(name: 'TV Commedies')
    category_dramas = Category.create(name: 'TV Dramas')
    category_reality = Category.create(name: 'Reality TV')

    Video.create(title: 'Family Guy', \
      description: 'Family Guy is an American animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company. The series centers on the Griffins, a dysfunctional family consisting of parents Peter and Lois; their children Meg, Chris, and Stewie; and their anthropomorphic pet dog Brian. The show is set in the fictional city of Quahog, Rhode Island, and exhibits much of its humor in the form of cutaway gags that often lampoon American culture.', \
      small_cover_url: '/tmp/family_guy.jpg', \
      category: category_commedies)
    video_futurama = Video.create(title: 'Futurama', \
      description: 'Futurama is an American animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company. The series follows the adventures of a late-20th-century New York City pizza delivery boy, Philip J. Fry, who, after being unwittingly cryogenically frozen for one thousand years, finds employment at Planet Express, an interplanetary delivery company in the retro-futuristic 31st century. The series was envisioned by Groening in the late 1990s while working on The Simpsons, later bringing Cohen aboard to develop storylines and characters to pitch the show to Fox.', \
      small_cover_url: '/tmp/futurama.jpg', \
      category: category_commedies)
    video_monk = Video.create(title: 'Monk', \
      description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk. It originally ran from 2002 to 2009 and is primarily a mystery series, although it has dark and comic touches. The series was produced by Mandeville Films and Touchstone Television (although the corporate name changed to ABC Studios in the course of the series, the Touchstone Television logo remained throughout, making Monk the last surviving series to carry it) in association with Universal Television.', \
      small_cover_url: '/tmp/monk.jpg', \
      large_cover_url: '/tmp/monk_large.jpg', \
      category: category_dramas)
    video_south_park = Video.create(title: 'South Park', \
      description: 'South Park is an American animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network. Intended for mature audiences, the show has become famous for its crude language and dark, surreal humor that lampoons a wide range of topics. The ongoing narrative revolves around four boys-Stan Marsh, Kyle Broflovski, Eric Cartman and Kenny McCormick-and their bizarre adventures in and around the titular Colorado town.', \
      small_cover_url: '/tmp/south_park.jpg', \
      category: category_commedies)
    user_alex = User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
  end

  scenario "with existing user" do
    visit sign_in_path
    fill_in "Email Address", with: "alex@bibiano.es"
    fill_in "Password", with: "1234"
    click_button "Sign in"
    page.should have_content "Welcome, Alex Bibiano"
    find(:xpath, "//img[@src='/tmp/futurama.jpg']/..").click
    page.has_selector?('h3', :text => 'Futurama')
    within(".video_info .actions") do
      click_link "My Queue"
    end
    page.should have_content "Futurama"
    click_link 'Futurama'
    page.has_selector?('h3', :text => 'Futurama')
    within(".video_info .actions") do
      page.should_not have_link "My Queue"
    end
    visit home_path
    find(:xpath, "//img[@src='/tmp/south_park.jpg']/..").click
    within(".video_info .actions") do
      click_link "My Queue"
    end
    visit home_path
    find(:xpath, "//img[@src='/tmp/monk.jpg']/..").click
    within(".video_info .actions") do
      click_link "My Queue"
    end
    page.should have_content "South Park"
    page.should have_content "Monk"
    find_field('queue_items_1_position').value.should eq "1"
    find_field('queue_items_2_position').value.should eq "2"
    find_field('queue_items_3_position').value.should eq "3"
    fill_in('queue_items_1_position', :with => '3')
    fill_in('queue_items_2_position', :with => '2')
    fill_in('queue_items_3_position', :with => '1')
    click_on "Update Instant Queue"
    find_field('queue_items_1_position').value.should eq "3"
    find_field('queue_items_2_position').value.should eq "2"
    find_field('queue_items_3_position').value.should eq "1"
  end
end