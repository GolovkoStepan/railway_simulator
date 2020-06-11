# frozen_string_literal: true

require_relative 'train'

module RailwaySimulator
  # Passenger train class
  class PassengerTrain < Train
    def add_carriage(carriage)
      raise ArgumentError unless carriage.is_a? PassengerCarriage

      super(carriage)
    end
  end
end
