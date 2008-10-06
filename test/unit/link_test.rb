require 'test_helper'

class LinkTest < Test::Unit::TestCase
  should_belong_to :creator
  should_have_many :users, :through => :votes
end
