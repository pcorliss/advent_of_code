require 'set'

module Advent

  class Blank
    attr_accessor :debug

    def initialize(input)
      @debug = false
    end

    def debug!
      @debug = true
    end
  end
end
