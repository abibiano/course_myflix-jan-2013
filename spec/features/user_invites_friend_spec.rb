require 'spec_helper'

feature 'User invites friend', js: true do

  scenario "User successfully invites friend to join myflix" do
    alice = Fabricate(:user)
    sign_in(alice)
    visit new_invitation_path
    fill_in "Friend's Name", with: "Chris Lee"
    fill_in "Friend's Email", with: "chris@example.com"
    fill_in "Invitation Message", with: "Hello please join this"
    click_button "Send Invitation"

    last_email.to.should include('chris@example.com')
    invitation = Invitation.last
    visit register_path(invitation.token)
    fill_in "Password", with: "123"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "4 - April", from: "date_month"
    select "2017", from: "date_year"
    click_button "Sign Up"

    page.should have_content "Welcome, Chris Lee"
  end
end