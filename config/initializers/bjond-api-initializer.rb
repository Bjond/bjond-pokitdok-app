require 'bjond-api'

integration_app = BjondIntegration::BjondAppDefinition.new
integration_app.author      = 'Bjond, Inc.'
integration_app.name        = 'my integration app'
integration_app.description = 'Testing API functionality'
integration_app.iconURL    = 'https://platform.pokitdok.com/documentation/v4/images/logo.png'
integration_app.configURL  = "#{Rails.application.config.action_controller.default_url_options[:host] || `hostname`}/pokitdok-app/services/"
integration_app.rootEndpoint = "#{Rails.application.config.action_controller.default_url_options[:host] || `hostname`}/pokitdok-app/services/"


BjondIntegration::BjondAppConfig.instance.active_definition = integration_app