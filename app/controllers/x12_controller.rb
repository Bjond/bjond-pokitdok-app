class X12Controller < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:incoming]

  require 'bjond-api'

  def incoming
    config = BjondApi::BjondAppConfig.instance
    puts request.raw_post
    status = 'OK'
    BjondRegistration.all.each do |r|
      pdc = PokitDokConfiguration.find_by_bjond_registration_id(r.id)
      if (pdc.nil?)
        status = status + '. Could not find PokitDokConfiguration for registration id ' + r.id
      end
      parsed = JSON.parse(request.raw_post)
      parsed[:bjondPersonId] = pdc.sample_person_id
      parsed[:requestType]   = 'Authorization'
      if (!parsed["event"].nil?)
        if(!parsed["event"]["provider"].nil?)
          parsed[:providerName] = parsed["event"]["provider"]["organization_name"]
        end
        if(!parsed["event"]["diagnoses"].nil? && parsed["event"]["diagnoses"].length > 0)
          parsed[:diagnosisCode] = parsed["event"]["diagnoses"].first["code"]
        end
      end
      BjondApi::fire_event(r, parsed.to_json, config.active_definition.integrationEvent.first.id)
    end
    render :json => {
      :status => status,
      :data => 'Message relayed to Bjond'
    }
  end

end
