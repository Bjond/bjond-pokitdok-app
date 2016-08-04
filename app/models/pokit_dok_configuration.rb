class PokitDokConfiguration < ActiveRecord::Base
  belongs_to :bjond_registration

  def self.destroy_unused_configurations
    PokitDokConfiguration.all.each do |c|
      if c.bjond_registration.nil?
        c.destroy
      end
    end
  end
end
