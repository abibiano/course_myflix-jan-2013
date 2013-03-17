require 'spec_helper'

feature 'User invites friend' do
  given(:alice) { Fabricate(:user) }
  scenario "User successfully invites friend to join myflix" do
    sign_in(alice)
    visit new_invitation_path
    fill_in "Friend's Name", with: "Chris Lee"
    fill_in "Friend's Email", with: "chris@example.com"
    fill_in "Invitation Message", with: "Hello please join this"
    click_button "Send Invitation"

    last_email.to.should include('chris@example.com')
    invitation = Invitation.last
    visit register_url(invitation.token)
    fill_in "Password", with: "123"
    click_button "Sign Up"

    page.should have_content "Welcome, Chris Lee"
  end
end