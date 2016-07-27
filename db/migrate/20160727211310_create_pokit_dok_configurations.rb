class CreatePokitDokConfigurations < ActiveRecord::Migration
  def change
    create_table :pokit_dok_configurations do |t|
      t.string :client_id
      t.string :secret
      t.string :registration_id

      t.timestamps null: false
    end
  end
end
