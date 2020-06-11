# frozen_string_literal: true

require_relative 'common/company'
require_relative 'common/instance_counter'
require_relative 'common/train_errors'

module RailwaySimulator
  # Train class
  class Train
    include Common::TrainErrors
    include Common::Company
    include Common::InstanceCounter

    NUMBER_FORMAT = /^(\w{3}|\d{3})-?(\w{2}|\d{2})$/.freeze
    MAX_SPEED     = 100

    attr_accessor :number
    attr_reader   :speed, :current_station, :route

    class << self
      def find(number = nil)
        @instances&.find { |elem| elem.number == number }
      end

      private

      def add_instance(instance)
        @instances ||= []
        @instances << instance
      end
    end

    def initialize(number)
      @number    = number
      @speed     = 0
      @carriages = []

      validate!

      self.class.send(:add_instance, self)
      send(:register_instance)
    end

    def carriages
      return @carriages unless block_given?

      @carriages.map { |carriage| yield(carriage) }
    end

    def speed_up
      @speed = MAX_SPEED
    end

    def brake
      @speed = 0
    end

    def move_ahead
      move to_station: :next_station
    end

    def move_back
      move to_station: :previous_station
    end

    def previous_station
      find_station(-1)
    end

    def next_station
      find_station(1)
    end

    def route_present?
      @current_station.is_a? Station
    end

    def carriages_present?
      @carriages.any?
    end

    def add_carriage(carriage)
      raise ArgumentError unless carriage.is_a? Carriage

      @carriages << carriage if @speed.zero?
    end

    def remove_carriage(carriage)
      @carriages.delete(carriage) if @speed.zero?
    end

    def carriages_count
      @carriages.count
    end

    def assign_route(route)
      raise ArgumentError unless route.is_a? Route

      @route = route
      @route.start_station.take_train(self)
      @current_station = @route.start_station
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def move(to_station:)
      return unless @route && @speed == MAX_SPEED
      return unless respond_to? to_station

      station = send(to_station)
      return unless station

      @current_station.send_train(self)
      @current_station = station
      @current_station.take_train(self)
    end

    def find_station(prev_or_next)
      return unless @route

      index = @route.all_stations.index(@current_station) + prev_or_next
      return if index.negative? || index >= @route.all_stations.count

      @route.all_stations[index]
    end

    protected

    def validate!
      raise NumberEmpty if @number.nil? || @number.empty?
      raise NumberWrongFormat if @number !~ NUMBER_FORMAT
    end
  end
end
