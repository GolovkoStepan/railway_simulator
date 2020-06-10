# frozen_string_literal: true

require_relative 'carriage'

# rubocop:disable Style/AsciiComments

module RailwaySimulator
  # Класс "Пассажирский вагон"
  class PassengerCarriage < Carriage
    attr_reader :occupied_places

    def initialize(name:, places: 50)
      @total_places    = places.to_i
      @occupied_places = 0
      super(name)
    end

    def take_place
      @occupied_places += 1 if take_place?
    end

    def take_place?
      @occupied_places < @total_places
    end

    def free_places
      @total_places - @occupied_places
    end
  end
end

# rubocop:enable Style/AsciiComments
