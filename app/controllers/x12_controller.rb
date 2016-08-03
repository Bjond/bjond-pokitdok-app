class X12Controller < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:incoming]

  def incoming
    puts request.raw_post
    render :json => {
      :status => 'OK',
      :data => 'Message relayed to Bjond'
    }
  end

end
