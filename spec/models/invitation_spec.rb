require 'spec_helper'

describe Invitation do
  it { should validate_presence_of(:friend_full_name) }
  it { should validate_presence_of(:friend_email) }
  it { should belong_to(:user) }

  it "has token after create" do
    user = Fabricate(:user)
    invitation = Invitation.create(user: user, friend_email: "alice@example.com", friend_full_name: "Alice")
    expect(invitation.token).to_not be_empty
  end
end