require 'test_helper'

class VoteTest < Test::Unit::TestCase
  fixtures :all

  should_belong_to :user
  should_belong_to :link

  should_require_attributes :user
  should_require_attributes :link
  should_require_unique_attributes :user_id, :scoped_to => :link_id
end
