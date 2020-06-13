# frozen_string_literal: true

module RailwaySimulator
  module Common
    # Custom class fields validations
    module Validation
      VALIDATORS = {
        presence: {
          exp: ->(attr, _state) { !attr.to_s.empty? },
          msg: 'Field %<attr>s must be present'
        },
        format: {
          exp: ->(attr, regexp) { attr =~ regexp },
          msg: 'Field %<attr>s have wrong format'
        },
        type: {
          exp: ->(attr, klass) { attr.is_a? klass },
          msg: 'Field %<attr>s has invalid type'
        }
      }.freeze

      class ValidationCustomError < StandardError; end

      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      # Class validation functional
      module ClassMethods
        def validations
          @validations ||= []
        end

        def validate(attr, options = {})
          @validations ||= []

          attr_validations = options.each_with_object([]) do |(key, value), arr|
            next unless VALIDATORS.key? key

            arr << {
              attr: attr,
              validator: VALIDATORS[key],
              params: value
            }
          end

          @validations += attr_validations
        end
      end

      # Instance validation functional
      module InstanceMethods
        def errors
          @errors ||= []
        end

        def validate!
          @errors = []

          self.class.validations.each do |validation|
            attr       = validation[:attr]
            msg        = validation[:validator][:msg]
            exp        = validation[:validator][:exp]
            params     = validation[:params]

            attr_value = instance_variable_get("@#{attr}")
            unless exp.call(attr_value, params)
              @errors << format(msg, attr: attr)
            end
          end

          raise ValidationCustomError if @errors.count.positive?
        end

        def valid?
          validate!
          true
        rescue ValidationCustomError
          false
        end
      end
    end
  end
end
