require 'spec_helper'

describe UserRegistration do
  context "with valid user input" do
    let(:user) { Fabricate.build(:user) }
    let(:token) { "123" }
    context "with valid card info" do
      before do
        charge = double('charge', successful?: true)
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end
      it "creates the user" do
        expect {
          UserRegistration.new(user).register_user(token)
        }.to change(User, :count).by(1)
      end
      it "create relationship if invitation exists" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, user: alice, friend_email: user.email, friend_full_name: user.full_name)
        UserRegistration.new(user).register_user(token)
        expect(User.last.following? alice).to be_true
        expect(alice.following? User.last).to be_true
      end
      it "does not create relationship if invitation dosent exists" do
        expect {
          UserRegistration.new(user).register_user(token)
        }.to_not change(Relationship, :count)
      end
      context "sends welcome email" do
        before do
          reset_email
        end
        it "sends out the email" do
          UserRegistration.new(user).register_user(token)
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end
        it "sends to the right recipient" do
          UserRegistration.new(user).register_user(token)
          expect(last_email.to).to eq [user[:email]]
        end
        it "has the right content" do
          UserRegistration.new(user).register_user(token)
          message = ActionMailer::Base.deliveries.last
          expect(message.html_part.body).to include(user.full_name)
        end
      end
    end
    context "with invalid card info" do
      before do
        charge = double('charge', successful?: false, error_message: "Your card was declined")
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end
      it "does not create the user" do
        expect {
          UserRegistration.new(user).register_user(token)
        }.to change(User, :count).by(0)
      end
      it "does not send the welcome email" do
        reset_email
        UserRegistration.new(user).register_user(token)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
  context "with invalid user input" do
    let(:user) { Fabricate.build(:user, full_name: nil) }
    let(:token) { "123" }
    context "with valid card info" do
      before do
        charge = double('charge', successful?: true)
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end
      it "does not create a user" do
        expect {
          UserRegistration.new(user).register_user(token)
        }.to_not change(User, :count)
      end
      it "does not charge the user" do
        UserRegistration.new(user).register_user(token)
        StripeWrapper::Charge.should_not_receive(:create)
      end
      it "does not send the welcome email" do
        reset_email
        UserRegistration.new(user).register_user(token)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end