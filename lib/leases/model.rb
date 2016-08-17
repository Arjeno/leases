require 'leases/model/base'
require 'leases/model/callbacks'

module Leases
  module Model

    extend ActiveSupport::Concern

    module ClassMethods

      ##
      # Marks model as a leaser.
      #
      # === Examples
      #
      # leases
      # leases :name => :slug
      # leases :name => Proc.new { |c| "acount_#{c.id}" }
      #
      def leases(options={})
        include Base
        include Callbacks

        shared_by_leasers

        Leases.leasing(self)
        self.leases_options = options
      end

      ##
      # Marks model as a shared model.
      # This prevents the model being multi-tenant.
      #
      # === Example
      #
      # class User < ActiveRecord::Base
      #   shared_by_leasers
      # end
      #
      def shared_by_leasers
        Apartment.excluded_models ||= []
        Apartment.excluded_models += [self.name]
        Apartment.excluded_models.uniq!

        Apartment::Tenant.init unless ARGV.any? { |arg| arg =~ /\Aassets:(?:precompile|clean)\z/ }
      end

    end

  end
end

ActiveRecord::Base.send(:include, Leases::Model)
