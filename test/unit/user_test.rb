require 'test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :all

  should_have_many :links, :through => :votes
  should_have_many :created
  
  should_require_attributes :email
  should_require_unique_attributes :email
  should_require_attributes :name
  should_require_attributes :password_hash

  should_protect_attributes :password_hash
end
