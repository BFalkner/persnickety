require 'test_helper'

class Links::VoteControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper

  def setup
    @controller = Links::VoteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  context "while not logged in" do
    context "on POST to create" do
      setup do
        post :create, :link_id => 1
      end

      should_redirect_to "login_url"
    end
  end
end
