# frozen_string_literal: true

require_relative 'common/instance_counter'

module RailwaySimulator
  # The Route class that implements the route logic.
  class Route
    include Common::InstanceCounter

    attr_accessor :name
    attr_accessor :start_station
    attr_accessor :end_station
    attr_reader   :way_stations

    def initialize(name:, start_station:, end_station:)
      @start_station = start_station
      @end_station   = end_station
      @name          = name
      @way_stations  = []

      validate!

      send(:register_instance)
    end

    def add_way_station(station)
      raise ArgumentError unless station.is_a? Station

      @way_stations << station
    end

    def remove_way_station(station)
      @way_stations.delete(station)
    end

    def all_stations
      [@start_station] + @way_stations + [@end_station]
    end

    def valid?
      validate!
      true
    rescue ArgumentError
      false
    end

    protected

    def validate!
      unless @start_station.is_a? Station
        raise ArgumentError 'Start station have wrong type'
      end

      unless @end_station.is_a? Station
        raise ArgumentError 'End station have wrong type'
      end

      raise ArgumentError 'Name must be filled' if @name.nil? || @name.empty?
    end
  end
end
