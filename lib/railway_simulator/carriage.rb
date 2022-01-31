# frozen_string_literal: true

require_relative 'common/company'
require_relative 'common/validations'

module RailwaySimulator
  # Carriage class
  class Carriage
    include Common::Company
    include Common::Validation

    attr_accessor :name

    validate :name, presence: true, type: String

    def initialize(name)
      @name = name
      validate!
    end
  end
end
