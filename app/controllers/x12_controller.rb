class X12Controller < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:incoming]

  require 'bjond-api'

  def incoming
    config = BjondApi::BjondAppConfig.instance
    puts request.raw_post
    payload = {
      :event_data => request.raw_post
    }
    BjondRegistration.all.each do |r|
      BjondApi::fire_event(r, payload, config.active_definition.integrationEvent.first.id)
    end
    render :json => {
      :status => 'OK',
      :data => 'Message relayed to Bjond'
    }
  end

end
