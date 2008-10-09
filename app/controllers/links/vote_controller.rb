class Links::VoteController < ApplicationController
  before_filter :login_required, :only => [ :new, :create ], :redirect_to => "login_url"

  def create
    @vote = Vote.new :user => current_user, :link => Link.find(params[:link_id])
    if @vote.save
      render :status => :created
    else
      render :status => :bad_request
    end
  end

end
