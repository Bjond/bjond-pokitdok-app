require 'bjond-api'

config = BjondApi::BjondAppConfig.instance

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

config.active_definition = BjondApi::BjondAppDefinition.new.tap do |app_def|
  app_def.id           = '1e8dab76-2493-48e9-992d-fc04d6d8dabc'
  app_def.author       = 'Bjond, Inc.'
  app_def.name         = 'Eligibility / Authorization'
  app_def.description  = 'Adapter between Bjond and PokitDok API.'
  app_def.iconURL      = 'https://platform.pokitdok.com/documentation/v4/images/logo.png'
  app_def.integrationEvent = [
    BjondApi::BjondEvent.new.tap do |e|
      e.id = 'c2784256-339d-481f-8163-5b77c506d72b'
      e.jsonKey = 'eligibilityRequest'
      e.name = 'Eligibility Request'
      e.description = 'This event represents the submission of an eligibility request'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = '2091de2e-dcf9-461a-b66c-ea4c01081f9c'
          f.jsonKey = 'patient'
          f.name = 'Patient'
          f.description = 'The patient identifier'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '13f9dbb4-20db-4be0-b510-b630180e6488'
          f.jsonKey = 'insuranceFlag'
          f.name = 'Coverage Indicator'
          f.description = 'Insurance Flag'
          f.fieldType = 'MultipleChoice'
          f.options = [
            'True',
            'False'
          ]
          f.event = e.id
        end
      ]
    end
  ]
  app_def.integrationConsequence = [
    BjondApi::BjondConsequence.new.tap do |consequence|
      consequence.id = '8e3e75ba-4278-41cd-b005-70d27bbcc519'
      consequence.jsonKey = 'checkEligibility'
      consequence.name = 'Check Eligibility'
      consequence.description = 'When this is fired, Axis will be updated with the event data that triggered the rule (if appropriate). If medical data is not in the condition, nothing will happen.'
      consequence.webhook = "\/consequence\/update"
      consequence.serviceId = app_def.id
    end,
    BjondApi::BjondConsequence.new.tap do |consequence|
      consequence.id = '1a33cd24-17fb-48be-b9fa-5046814d6b96'
      consequence.jsonKey = 'checkEligibilityPokitdok'
      consequence.name = 'Check Eligibility with PokitDok'
      consequence.description = 'When this is fired, the event data will be sent to pokitdok to check availability.'
      consequence.webhook = "\/consequence\/checkpokitdok"
      consequence.serviceId = app_def.id
    end
  ]
end