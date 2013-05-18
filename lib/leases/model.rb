require 'leases/model/base'
require 'leases/model/callbacks'

module Leases
  module Model

    extend ActiveSupport::Concern

    module ClassMethods

      def leases(options={})
        include Base
        include Callbacks

        shared_by_leasers

        Leases.leasing(self)
        self.leases_options = options
      end

      def shared_by_leasers
        Apartment.excluded_models ||= []
        Apartment.excluded_models += [self.name]
        Apartment.excluded_models.uniq!
      end

    end

  end
end

ActiveRecord::Base.send(:include, Leases::Model)
