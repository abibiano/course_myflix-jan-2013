require 'spec_helper'

describe StripeWrapper::Charge do
  before do
    StripeWrapper.set_api_key
  end

  let(:token) do
    Stripe::Token.create(
      card: {
        number: card_number,
        exp_month: 3,
        exp_year: 2016,
        cvc: 314
      }
    ).id
  end

  let(:card_number) { "4242424242424242" }

  it "passes throug the call the stripe api" do
      response = StripeWrapper::Charge.create(amount: 1000, card: token, description: "payinguser@example.com")
      response.amount.should == 1000
  end

  context "with valid credit card" do
    let(:card_number) { "4242424242424242" }

    it "charges the card successfully" do
      response = StripeWrapper::Charge.create(amount: 300, card: token)
      response.should be_successful
    end
  end

  context "with invalid credit card" do
    let(:card_number) { "4000000000000002" }
    let(:response) { StripeWrapper::Charge.create(amount: 300, card: token) }

    it "does not charge the card" do
      response.should_not be_successful
    end

    it "contains an error message" do
      response.error_message.should == "Your card was declined"
    end
  end
end