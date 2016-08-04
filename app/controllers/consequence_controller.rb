class ConsequenceController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:update, :checkpokitdok]
  before_action :set_registration, :only => [:update, :checkpokitdok]
  before_action :set_pokitdok_config, :only => [:checkpokitdok]

  def update
    puts "Updating!****************************"
    puts request.raw_post
    render :json => {
      :status => 'OK'
    }
  end

  def checkpokitdok
    puts "Checking pokitdok!****************************"
    
    require 'pokitdok'

    pd = PokitDok::PokitDok.new(@pokitdok_config.client_id, @pokitdok_config.secret)

    # Eligibility
    @eligibility_query = {
      member: {
          birth_date: '1970-01-01',
          first_name: 'Jane',
          last_name: 'Doe',
          id: 'W000000000'
      },
      provider: {
          first_name: 'JEROME',
          last_name: 'AYA-AY',
          npi: '1467560003'
      },
      service_types: ['health_benefit_plan_coverage'],
      trading_partner_id: 'MOCKPAYER'
    }

    result = pd.eligibility @eligibility_query
    puts result
    
    # puts request.raw_post

    render :json => {
      :status => 'OK'
    }
  end

  private
    def set_registration
      @registration = BjondRegistration.find_registration_by_remote_ip(request.remote_ip)
    end

    def set_pokitdok_config
      @pokitdok_config = PokitDokConfiguration.find_by_bjond_registration_id(@registration.id)
    end

end
