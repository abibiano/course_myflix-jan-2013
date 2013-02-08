require 'spec_helper'

describe Review do
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:rating) }
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should ensure_inclusion_of(:rating).in_range(1..5) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:video_id) }

end