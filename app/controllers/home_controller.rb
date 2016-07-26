class HomeController < ApplicationController

  require 'pokitdok'

  def index
  end

  def call_pokitdok
    client = PokitDok::PokitDok.new(ENV['POKITDOK_CLIENT_ID'], ENV['POKITDOK_SECRET'])
    render :json => client.authorizations({
        event: {
            category: "health_services_review",
            certification_type: "initial",
            delivery: {
                quantity: 1,
                quantity_qualifier: "visits"
            },
            diagnoses: [
                {
                    code: "R10.9",
                    date: "2016-01-25"
                }
            ],
            place_of_service: "office",
            provider: {
                organization_name: "KELLY ULTRASOUND CENTER, LLC",
                npi: "1760779011",
                phone: "8642341234"
            },
            services: [
                {
                    cpt_code: "76700",
                    measurement: "unit",
                    quantity: 1
                }
            ],
            type: "diagnostic_medical"
        },
        patient: {
            birth_date: "1970-01-25",
            first_name: "JANE",
            last_name: "DOE",
            id: "1234567890"
        },
        provider: {
            first_name: "JEROME",
            npi: "1467560003",
            last_name: "AYA-AY"
        },
        trading_partner_id: "MOCKPAYER"
    })
  end

end