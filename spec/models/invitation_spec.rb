require 'spec_helper'

describe Invitation do
  it { should validate_presence_of(:friend_full_name) }
  it { should validate_presence_of(:friend_email) }
  it { should belong_to(:user) }
end