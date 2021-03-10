require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Spinlock
    attr_accessor :debug
    attr_reader :skip

    def initialize(input)
      @debug = false
    end

    def debug!
      @debug = true
    end
  end
end
