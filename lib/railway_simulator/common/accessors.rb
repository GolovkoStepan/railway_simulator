# frozen_string_literal: true

module RailwaySimulator
  module Common
    # Additional accessors for classes
    module Accessors
      def attr_accessor_with_history(*attrs)
        attrs.each do |attr|
          hist = "#{attr}_history"

          define_method hist, -> { instance_variable_get("@#{hist}") || [] }
          define_method attr, -> { instance_variable_get("@#{attr}") }

          define_method "#{attr}=" do |value|
            history = send(hist) << value

            instance_variable_set("@#{attr}", value)
            instance_variable_set("@#{hist}", history)
          end
        end
      end

      def strong_attr_accessor(attr, klass)
        define_method attr, -> { instance_variable_get("@#{attr}") }

        define_method "#{attr}=" do |value|
          raise TypeError, "Invalid type. Must be a #{klass}" unless value.is_a?(klass)

          instance_variable_set("@#{attr}", value)
        end
      end
    end
  end
end
