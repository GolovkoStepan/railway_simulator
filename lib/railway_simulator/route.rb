# frozen_string_literal: true

require_relative 'common/instance_counter'
require_relative 'common/accessors'
require_relative 'common/validations'
require_relative 'station'

module RailwaySimulator
  # The Route class that implements the route logic.
  class Route
    extend  Common::Accessors
    include Common::InstanceCounter
    include Common::Validation

    attr_accessor :name
    attr_reader   :way_station

    strong_attr_accessor :start_station, RailwaySimulator::Station
    strong_attr_accessor :end_station,   RailwaySimulator::Station

    validate :name, presence: true, type: String

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
  end
end
