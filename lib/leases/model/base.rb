module Leases
  module Model
    module Base

      extend ActiveSupport::Concern

      included do

        cattr_accessor :leases_options
        self.leases_options = {}

      end

      module ClassMethods

        ##
        # Returns array of leaser names (schema names).
        #
        # === Example
        #
        # Account.leaser_names # => ['account-1', 'account-2']
        #
        # === Returns
        #
        # [Array] List of leaser names
        #
        def leaser_names
          name = self.leases_options[:name]

          if name.is_a?(Symbol)
            # Simply pluck the column
            self.pluck(name)
          elsif name.is_a?(Proc)
            # Name is a proc, find record in matches
            names = []
            self.find_each do |object|
              names << object.leaser_name
            end
            names
          else
            # Default option: pluck ids and prefix it
            prefix  = self.name.parameterize
            ids     = self.pluck(:id)
            ids.collect { |id| [prefix, id].join('-') }
          end
        end

      end

      ##
      # Name of the leaser, used for naming the database.
      # This can be set in the leaser_options. Must be unique.
      #
      def leaser_name
        name = self.class.leases_options[:name]

        if name.is_a?(Symbol)
          send(name)
        elsif name.is_a?(Proc)
          name.call(self)
        else
          [self.class.name.parameterize, id].join('-')
        end
      end

      ##
      # Enter the leaser-context.
      #
      # === Example
      #
      # account.enter
      #
      def enter
        Apartment::Tenant.switch(leaser_name)
        Leases.current = self
      end

      ##
      # Leave the leaser-context.
      #
      # === Example
      #
      # account.leave
      #
      def leave
        Leases.current = nil
        Apartment::Tenant.reset
      end

      ##
      # Visit a leaser by entering and leaving.
      # Very useful for executing code in a leaser-context
      #
      # === Example
      #
      # account.visit { User.find(1) }
      #
      def visit(&block)
        enter
        begin
          yield
        ensure
          leave
        end
      end

      ##
      # Create a new lease.
      # This is usually called when a model is created.
      #
      # === Example
      #
      # account.lease!
      #
      def lease!
        Apartment::Tenant.create(leaser_name)
      end

      ##
      # Break a lease.
      # This is usually called when a model is destroyed.
      #
      # === Example
      #
      # account.break!
      #
      def break!
        Apartment::Tenant.drop(leaser_name)
      end

    end
  end
end
