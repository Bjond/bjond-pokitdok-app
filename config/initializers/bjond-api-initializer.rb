require 'bjond-api'

integration_app = BjondIntegration::BjondAppDefinition.new
integration_app.id           = '1e8dab76-2493-48e9-992d-fc04d6d8dabc'
integration_app.author       = 'Bjond, Inc.'
integration_app.name         = 'my integration app'
integration_app.description  = 'Testing API functionality'
integration_app.iconURL      = 'https://platform.pokitdok.com/documentation/v4/images/logo.png'
integration_app.configURL    = "http://#{Rails.application.config.action_controller.default_url_options[:host] || `hostname`}/bjond-app/services"
integration_app.rootEndpoint = "http://#{Rails.application.config.action_controller.default_url_options[:host] || `hostname`}/bjond-app/services"


BjondIntegration::BjondAppConfig.instance.active_definition = integration_app


BjondIntegration::BjondAppConfig.instance.group_configuration_schema = {
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

BjondIntegration::BjondAppConfig.instance.group_configuration = {
  :client_id => ENV['pokitdok_client_id'], :secret => ENV['pokitdok_secret']
}

BjondIntegration::BjondAppConfig.instance.encryption_key_name = 'BJOND_POKITDOK_ENCRYPTION_KEY'