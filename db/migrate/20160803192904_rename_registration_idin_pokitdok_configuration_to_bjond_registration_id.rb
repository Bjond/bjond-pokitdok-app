class RenameRegistrationIdinPokitdokConfigurationToBjondRegistrationId < ActiveRecord::Migration
  def change
    rename_column :pokit_dok_configurations, :registration_id, :bjond_registration_id
  end
end
