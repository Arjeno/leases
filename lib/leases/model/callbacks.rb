module Leases
  module Model
    module Callbacks

      extend ActiveSupport::Concern

      ##
      # Model callbacks
      #
      # === Examples
      #
      # on_enter :do_something
      # on_leave :do_something
      # on_lease :do_something
      # on_break :do_something
      #

      included do

        ## Callbacks

        after_create :lease!
        after_destroy :break!

        ## Custom callbacks

        define_model_callbacks :enter, :leave, :lease, :break

        class << self
          alias :on_enter :after_enter
          alias :on_leave :after_leave
          alias :on_lease :after_lease
          alias :on_break :after_break
        end

      end

      def enter
        run_callbacks :enter do
          super
        end
      end

      def leave
        run_callbacks :leave do
          super
        end
      end

      def lease!
        run_callbacks :lease do
          super
        end
      end

      def break!
        run_callbacks :break do
          super
        end
      end

    end
  end
end
