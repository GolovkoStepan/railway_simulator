# frozen_string_literal: true

require_relative 'common/company'

# rubocop:disable Style/AsciiComments

module RailwaySimulator
  # Класс "Вагон"
  class Carriage
    include Common::Company

    attr_accessor :name

    def initialize(name)
      @name = name
      validate!
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def validate!
      raise ArgumentError, 'Name must be filled' if @name.nil? || @name.empty?
    end
  end
end

# rubocop:enable Style/AsciiComments
