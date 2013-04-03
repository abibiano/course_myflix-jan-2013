require 'spec_helper'

feature 'New user registers' do
  scenario "valid user inputs and valid credit card", js: true do
    visit register_path
    fill_in "Email", with: "alice@example.com"
    fill_in "Password", with: "1234"
    fill_in "Full name", with: "Alice"

    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "4 - April", from: "date_month"
    select "2017", from: "date_year"
    click_button "Sign Up"
    page.should have_content "Thank you for your payment."
    page.should have_content "User was succesfully created"
    page.should have_content "Welcome, Alice"
  end
  scenario "valid user inputs and invalid credit card values", js: true  do
    visit register_path
    fill_in "Email", with: "alice@example.com"
    fill_in "Password", with: "1234"
    fill_in "Full name", with: "Alice"

    select "4 - April", from: "date_month"
    select "2017", from: "date_year"
    click_button "Sign Up"
    page.should have_content "This card number looks invalid"
  end


  scenario "valid user inputs and declined credit card", js: true  do
    visit register_path
    fill_in "Email", with: "alice@example.com"
    fill_in "Password", with: "1234"
    fill_in "Full name", with: "Alice"

    fill_in "Credit Card Number", with: "4000000000000002"
    fill_in "Security Code", with: "123"
    select "4 - April", from: "date_month"
    select "2017", from: "date_year"
    click_button "Sign Up"
    page.should have_content "Your card was declined"
  end

  scenario "invalid user inputs" do
    visit register_path
    fill_in "Email", with: "alice@example.com"

    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "4 - April", from: "date_month"
    select "2017", from: "date_year"
    click_button "Sign Up"
    page.should have_content "Please fix the errors below."
  end
end