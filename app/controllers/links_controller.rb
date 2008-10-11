class LinksController < ApplicationController
  before_filter :login_required, :only => [ :new, :create ], :redirect_to => "login_url"

  def index
    @links = Link.find_by_probability(current_user || User.new).sort_by {|l| -l.probability}
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new params[:link]
    @link.creator = current_user
    if @link.save
      render :status => :created
    else
      render :action => :new, :status => :bad_request
    end
  end

end
