# frozen_string_literal: true

require_relative 'common/company'
require_relative 'common/instance_counter'
require_relative 'common/train_errors'

# rubocop:disable Style/AsciiComments

module RailwaySimulator
  # Класс "Поезд"
  class Train
    include Common::TrainErrors
    include Common::Company
    include Common::InstanceCounter

    NUMBER_FORMAT = /^(\w{3}|\d{3})-?(\w{2}|\d{2})$/.freeze
    MAX_SPEED     = 100

    # Номер поезда
    attr_accessor :number
    # Может возвращать текущую скорость
    attr_reader :speed
    # Текущая станция
    attr_reader :current_station
    # Маршрут
    attr_reader :route

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
      # Имеет номер (произвольная строка)
      @number = number
      # Текущая скорость
      @speed = 0
      # Может иметь вагоны
      @carriages = []

      validate!

      self.class.send(:add_instance, self)
      send(:register_instance)
    end

    def carriages
      return @carriages unless block_given?

      @carriages.map { |carriage| yield(carriage) }
    end

    # Может набирать скорость
    def speed_up
      @speed = MAX_SPEED
    end

    # Может тормозить (сбрасывать скорость до нуля)
    def brake
      @speed = 0
    end

    # Перемещение на одну станцию вперед
    def move_ahead
      move to_station: :next_station
    end

    # Перемещение на одну станцию назад
    def move_back
      move to_station: :previous_station
    end

    # Предыдущая станция
    def previous_station
      find_station(-1)
    end

    # Следующая станция
    def next_station
      find_station(1)
    end

    # Есть маршрут
    def route_present?
      @current_station.is_a? Station
    end

    # Есть вагоны
    def carriages_present?
      @carriages.any?
    end

    # Может прицеплять вагон
    def add_carriage(carriage)
      raise ArgumentError unless carriage.is_a? Carriage

      @carriages << carriage if @speed.zero?
    end

    # Может отцеплять вагон
    def remove_carriage(carriage)
      @carriages.delete(carriage) if @speed.zero?
    end

    # Кол-во вагонов
    def carriages_count
      @carriages.count
    end

    # Может принимать маршрут следования (объект класса Route)
    def assign_route(route)
      raise ArgumentError unless route.is_a? Route

      @route = route
      # При назначении маршрута поезду, поезд
      # автоматически помещается на первую станцию в маршруте.
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

# rubocop:enable Style/AsciiComments
