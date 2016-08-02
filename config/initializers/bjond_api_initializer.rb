require 'bjond-api'

integration_app = BjondApi::BjondAppDefinition.new
integration_app.id           = '1e8dab76-2493-48e9-992d-fc04d6d8dabc'
integration_app.author       = 'Bjond, Inc.'
integration_app.name         = 'Bjond-PokitDok-App'
integration_app.description  = 'Adapter between Bjond and PokitDok API.'
integration_app.iconURL      = 'https://platform.pokitdok.com/documentation/v4/images/logo.png'
integration_app.configURL    = "http://#{Rails.application.config.action_controller.default_url_options[:host] || `hostname`}/bjond-app/services"
integration_app.rootEndpoint = "http://#{Rails.application.config.action_controller.default_url_options[:host] || `hostname`}/bjond-app/services"
integration_app.integrationEvent = []

config = BjondApi::BjondAppConfig.instance

config.active_definition = integration_app


config.group_configuration_schema = {
  :id => 'urn:jsonschema:com:bjond:persistence:bjondservice:GroupConfiguration',
  :title => 'bjond-pokitdok-app-schema',
  :type  => 'object',
  :properties => {
    :client_id => {
      :type => 'string',
      :description => 'This is the client_id, as specified by your pokitdok credentials.',
      :title => 'Client ID'
    },
    :secret => {
      :type => 'string',
      :description => 'This is the client_secret, as specified by your pokitdok credentials.',
      :title => 'Client Secret'
    }
  },
  :required => ['client_id', 'secret']
}.to_json

config.group_configuration = {
  :client_id => ENV['pokitdok_client_id'], :secret => ENV['pokitdok_secret']
}

config.encryption_key_name = 'BJOND_POKITDOK_ENCRYPTION_KEY'

def config.configure_group(result, bjond_registration)
  pdconfig = PokitDokConfiguration.find_or_initialize_by(:bjond_registration_id => bjond_registration.id)
  if (pdconfig.client_id != result['client_id'] || pdconfig.secret = result['secret'])
    pdconfig.client_id = result['client_id']
    pdconfig.secret = result['secret']
    pdconfig.save
  end
  return pdconfig
end

def config.get_group_configuration(bjond_registration)
  pdconfig = PokitDokConfiguration.find_by_bjond_registration_id(bjond_registration.id)
  if (pdconfig.nil?)
    puts 'No configuration has been saved yet.'
    return {}
  else 
    return {:client_id => pdconfig.client_id, :secret => pdconfig.secret}
  end
end