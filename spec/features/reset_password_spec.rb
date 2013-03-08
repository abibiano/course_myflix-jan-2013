require 'spec_helper'

feature 'user reset his password' do

  scenario 'reseting password and sing in wih new password' do
    reset_email
    alex = Fabricate(:user, password: '1234', email: "alex@bibiano.es")
    visit sign_in_path
    click_link "Forgot password"
    fill_in "Email Address", with: "alex@bibiano.es"
    click_button 'Send Email'
    alex.reload
    last_email.to.should include(alex.email)
    last_email.body.should include("http://localhost:3000/password_resets/#{alex.password_reset_token}")

    visit edit_password_reset_path(alex.password_reset_token)

    fill_in "user_password", with: "new_password"
    fill_in "user_password_confirmation", with: "new_password"
    click_button "Reset Password"


    fill_in "Email", with: alex.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"

    page.should have_content "Welcome, #{alex.full_name}"
  end
end