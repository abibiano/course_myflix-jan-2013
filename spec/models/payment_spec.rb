require 'spec_helper'

describe Payment do
  it { should belong_to(:user) }

  it { should validate_presence_of(:transaction_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:amount) }
end