require 'spec_helper'

describe Review do
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:rating) }
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should ensure_inclusion_of(:rating).in_range(0..5) }

end