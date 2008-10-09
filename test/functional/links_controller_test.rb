require 'test_helper'

class LinksControllerTest < Test::Unit::TestCase
  def setup
    @controller = LinksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  context "on GET to index" do
    setup do
      get :index
    end
    
    should_assign_to :links
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end

  context "on GET to new" do
    setup do
      get :new
    end

    should_assign_to :link
    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash
  end

  context "on POST to create" do
    context "with valid data" do
      setup do
        post :create, :link => { :title => "Some title.", :url => "http://google.com/", :creator_id => 1 }
      end

      should_assign_to :link
      should_respond_with :created
      should_render_template :create
      should_not_set_the_flash
    end

    context "with invalid data" do
      setup do
        post :create
      end

      should_assign_to :link
      should_respond_with :bad_request
      should_render_template :new
      should_not_set_the_flash
    end
  end
end
