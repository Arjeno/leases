require 'rails'
require 'apartment'

module Leases
  class Railtie < Rails::Railtie

    config.to_prepare do
      Apartment.tenant_names = Proc.new { Leases.leaser_names }
    end

  end
end
