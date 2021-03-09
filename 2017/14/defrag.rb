require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Defrag
    attr_accessor :debug

    def initialize(input)
      @debug = false
    end

    def debug!
      @debug = true
    end
  end
end
