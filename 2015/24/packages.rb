require 'set'
require '../lib/grid.rb'

module Advent

  class Packages
    attr_accessor :debug

    def initialize(input)
      @debug = false
    end

    def debug!
      @debug = true
    end
  end
end
