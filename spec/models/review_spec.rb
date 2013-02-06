require 'spec_helper'

describe Review do
  it { should validate_presence_of(:text) }
  it { should belong_to(:user) }
  it { should belong_to(:video) }
end