require 'test_helper'

class UserTest < Test::Unit::TestCase
  should_have_many :links, :through => :votes
  should_have_many :created
end
