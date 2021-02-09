require 'set'
require '../lib/grid.rb'

module Advent

  class Screen
    attr_accessor :debug

    def initialize(input)
      @debug = false
    end

    def debug!
      @debug = true
    end
  end
end
