# frozen_string_literal: true

module RailwaySimulator
  module Common
    module TrainErrors
      class NumberEmpty < StandardError; end
      class NumberWrongFormat < StandardError; end
    end
  end
end
