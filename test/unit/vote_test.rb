require 'test_helper'

class VoteTest < Test::Unit::TestCase
  should_belong_to :user
  should_belong_to :link
end
