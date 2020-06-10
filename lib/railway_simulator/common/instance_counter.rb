# frozen_string_literal: true

module RailwaySimulator
  # Common logic
  module Common
    # Instance counter for classes
    module InstanceCounter
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      # Instance methods
      module InstanceMethods
        private

        def register_instance
          self.class.send(:instance_count=, self.class.instance_count + 1)
        end
      end

      # Class methods
      module ClassMethods
        def instance_count
          @instance_count || 0
        end

        private

        attr_writer :instance_count
      end
    end
  end
end
