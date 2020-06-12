# frozen_string_literal: true

require_relative 'carriage'

module RailwaySimulator
  # Cargo carriage class
  class CargoCarriage < Carriage
    attr_reader :occupied_volume

    def initialize(name:, volume: 1000)
      @total_volume    = volume.to_f
      @occupied_volume = 0
      super(name)
    end

    def take_volume(volume)
      @occupied_volume += volume.to_f if take_volume?(volume)
    end

    def take_volume?(volume)
      @total_volume >= @occupied_volume + volume.to_f
    end

    def free_volume
      @total_volume - @occupied_volume
    end
  end
end
