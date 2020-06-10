# frozen_string_literal: true

# rubocop:disable Style/AsciiComments

require_relative 'train'

module RailwaySimulator
  # Класс "Грузовой поезд"
  class FreightTrain < Train
    # Может прицеплять грузовой вагон
    def add_carriage(carriage)
      raise ArgumentError unless carriage.is_a? CargoCarriage

      super(carriage)
    end
  end
end

# rubocop:enable Style/AsciiComments
