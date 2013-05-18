module Leases
  module Controller

    extend ActiveSupport::Concern

    module ClassMethods

      # Uses a leaser as the context in a controller.
      #
      # => visit_as :current_account
      def visit_as(leaser)
        around_filter do |c, block|
          c.send(leaser).visit(&block)
        end
      end

    end

  end
end

ActionController::Base.send(:include, Leases::Controller)
