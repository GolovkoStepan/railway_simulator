# frozen_string_literal: true

require_relative 'train'

module RailwaySimulator
  # Freight train class
  class FreightTrain < Train
    def add_carriage(carriage)
      raise ArgumentError unless carriage.is_a? CargoCarriage

      super(carriage)
    end
  end
end
