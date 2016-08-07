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
    },
    :sample_person_id => {
      :type => 'string',
      :description => 'Bjond Person ID. This can be any person ID in the tenant.',
      :title => 'Bjond Patient ID'
    }
  },
  :required => ['client_id', 'secret']
}.to_json

config.encryption_key_name = 'BJOND_POKITDOK_ENCRYPTION_KEY'

def config.configure_group(result, bjond_registration)
  pdconfig = PokitDokConfiguration.find_or_initialize_by(:bjond_registration_id => bjond_registration.id)
  if (pdconfig.client_id != result['client_id'] || pdconfig.secret = result['secret']|| redox_config.sample_person_id != result['sample_person_id'])
    pdconfig.client_id = result['client_id']
    pdconfig.secret = result['secret']
    pdconfig.sample_person_id = result['sample_person_id']
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
    return pdconfig
  end
end

config.active_definition = BjondApi::BjondAppDefinition.new.tap do |app_def|
  app_def.id           = '1e8dab76-2493-48e9-992d-fc04d6d8dabc'
  app_def.author       = 'Bjond, Inc.'
  app_def.name         = 'Eligibility / Authorization'
  app_def.description  = 'Adapter between Bjond and PokitDok API.'
  app_def.iconURL      = 'http://2045253e14zf1be2pd2k25gh.wpengine.netdna-cdn.com/wp-content/uploads/2015/08/PokitDok-Taps-Lemhi-to-Lead-Oversubscribed-34M-Series-B-Round-300x300.png'
  app_def.integrationEvent = [
    BjondApi::BjondEvent.new.tap do |e|
      e.id = 'c2784256-339d-481f-8163-5b77c506d72b'
      e.jsonKey = 'x12Request'
      e.name = 'Incoming X12'
      e.description = 'This event represents the submission of an X12 message.'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = '2091de2e-dcf9-461a-b66c-ea4c01081f9c'
          f.jsonKey = 'bjondPersonId'
          f.name = 'Patient'
          f.description = 'The patient identifier'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '45947cf6-7de0-462d-847f-8de50fce683d'
          f.jsonKey = 'requestType'
          f.name = 'Request Type'
          f.description = 'This could be an authorization or an authorization request.'
          f.fieldType = 'MultipleChoice'
          f.options = [
            'Authorization',
            'Eligibility'
          ]
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
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '55793070-b1b2-47c8-986a-98c184181e1f'
          f.jsonKey = 'diagnosisCode'
          f.name = 'Diagnosis Code'
          f.description = 'Code to describe the condition for the authorization request.'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '2148bb19-c1cc-4b01-be59-66a3b2c7caca'
          f.jsonKey = 'providerName'
          f.name = 'Provider Name'
          f.description = 'Name of provider.'
          f.fieldType = 'String'
          f.event = e.id
        end
      ]
    end
  ]
  app_def.integrationConsequence = [
    BjondApi::BjondConsequence.new.tap do |consequence|
      consequence.id = '8e3e75ba-4278-41cd-b005-70d27bbcc519'
      consequence.jsonKey = 'checkEligibility'
      consequence.name = 'Send to Axis'
      consequence.description = 'When this is fired, Axis will be updated with the event data that triggered the rule (if appropriate). If medical data is not in the condition, nothing will happen.'
      consequence.webhook = "\/consequence\/update"
      consequence.serviceId = app_def.id
    end,
    BjondApi::BjondConsequence.new.tap do |consequence|
      consequence.id = '1a33cd24-17fb-48be-b9fa-5046814d6b96'
      consequence.jsonKey = 'checkEligibilityPokitdok'
      consequence.name = 'Send to PokitDok'
      consequence.description = 'When this is fired, the event data will be sent to pokitdok to check availability.'
      consequence.webhook = "\/consequence\/checkpokitdok"
      consequence.serviceId = app_def.id
    end
  ]
end