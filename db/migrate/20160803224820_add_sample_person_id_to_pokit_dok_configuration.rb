class AddSamplePersonIdToPokitDokConfiguration < ActiveRecord::Migration
  def change
    add_column :pokit_dok_configurations, :sample_person_id, :string
  end
end
