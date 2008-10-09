class Links::VoteController < ApplicationController
  before_filter :login_required, :only => [ :new, :create ], :redirect_to => "login_url"

  def create
  end

end
