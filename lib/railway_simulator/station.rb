# frozen_string_literal: true

require_relative 'common/instance_counter'
require_relative 'common/validations'

module RailwaySimulator
  # Station class
  class Station
    include Common::InstanceCounter
    include Common::Validation

    attr_reader :name

    validate :name, presence: true, type: String

    def initialize(name)
      @name   = name
      @trains = []

      validate!

      self.class.send(:add_instance, self)
    end

    def take_train(train)
      raise ArgumentError unless train.is_a?(Train)

      @trains << train
    end

    def trains(for_type: Train, &block)
      raise ArgumentError unless for_type.is_a?(Class)

      trains_filter = lambda do
        return @trains if for_type == Train

        @trains.select { |train| train.is_a?(for_type) }
      end

      return trains_filter.call.map(&block) if block_given?

      trains_filter.call
    end

    def send_train(train)
      @trains.delete(train)
    end

    class << self
      def all
        @instances || []
      end

      private

      def add_instance(instance)
        @instances ||= []
        @instances << instance
      end
    end
  end
end
