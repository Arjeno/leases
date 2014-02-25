module Leases
  module Model
    module Base

      extend ActiveSupport::Concern

      included do

        cattr_accessor :leases_options
        self.leases_options = {}

      end

      ##
      # Name of the leaser, used for naming the database.
      # This can be set in the leaser_options. Must be unique.
      #
      def leaser_name
        name = self.class.leases_options[:name]

        if name.nil?
          [self.class.name.parameterize, id].join('-')
        elsif name.is_a?(Symbol)
          send(name)
        elsif name.is_a?(Proc)
          name.call(self)
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
        Apartment::Database.switch(leaser_name)
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
        Apartment::Database.reset
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
        Apartment::Database.create(leaser_name)
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
        Apartment::Database.drop(leaser_name)
      end

    end
  end
end
