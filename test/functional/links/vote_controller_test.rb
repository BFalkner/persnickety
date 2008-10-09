require 'test_helper'

class Links::VoteControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper

  def setup
    @controller = Links::VoteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  context "while logged in" do
    setup do
      login_as(:aaron)
    end

    context "on POST to create" do
      context "with valid vote" do
        setup do
          post :create, :link_id => links(:one).id
        end
  
        should_respond_with :created
      end

      context "with duplicate vote" do
        setup do
          Vote.create :user => users(:aaron), :link => links(:one)
          post :create, :link_id => links(:one).id
        end
  
        should_respond_with :bad_request
      end
    end
  end

  context "while not logged in" do
    context "on POST to create" do
      setup do
        post :create, :link_id => links(:one).id
      end

      should_redirect_to "login_url"
    end
  end
end
