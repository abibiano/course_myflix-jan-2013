require 'spec_helper'

feature 'User sign in' do
  background do
    User.create(email: "alex@bibiano.es", password: "1234", full_name: "Alex Bibiano")
  end

  scenario "with existing user" do
    visit sign_in_path
    fill_in "Email Address", with: "alex@bibiano.es"
    fill_in "Password", with: "1234"
    click_button "Sign in"
    page.should have_content "Welcome, Alex Bibiano"
  end
end