require 'test_helper'

class LinkTest < Test::Unit::TestCase
  fixtures :all

  should_belong_to :creator
  should_have_many :users, :through => :votes

  should_require_attributes :title
  should_require_attributes :url
  should_require_unique_attributes :url
  should_require_attributes :creator_id
  should_protect_attributes :creator_id
end
