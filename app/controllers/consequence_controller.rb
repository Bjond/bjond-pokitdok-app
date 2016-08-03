class ConsequenceController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:update, :checkpokitdok]

  def update
    puts request.raw_post
    render :json => {
      :status => 'OK'
    }
  end

  def checkpokitdok
    puts request.raw_post
    render :json => {
      :status => 'OK'
    }
  end

end
