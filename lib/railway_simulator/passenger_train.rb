# frozen_string_literal: true

require_relative 'train'
require_relative 'common/validations'

module RailwaySimulator
  # Passenger train class
  class PassengerTrain < Train
    include Common::Validation

    validate :number,
             presence: true,
             format: NUMBER_FORMAT,
             type: String

    def add_carriage(carriage)
      raise ArgumentError unless carriage.is_a? PassengerCarriage

      super(carriage)
    end
  end
end
