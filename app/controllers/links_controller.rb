class LinksController < ApplicationController
  def index
    @links = Link.find :all
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.create params[:link]
    if @link.new_record?
      render :action => :new, :status => :bad_request
    else
      render :status => :created
    end
  end

end
