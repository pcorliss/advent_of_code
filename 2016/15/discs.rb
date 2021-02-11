require 'set'
require '../lib/grid.rb'

module Advent

  class Discs
    attr_accessor :debug
    attr_reader :discs

    def initialize(input)
      @debug = false
      @discs = input.each_line.map do |line|
        line.chomp!
        if line =~ /Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)./
          [$1.to_i, $2.to_i, $3.to_i]
        end
      end
    end

    def debug!
      @debug = true
    end

    DISC = 1
    POSITIONS = 2
    STARTING_POSITION = 3

    def position_at(t)

    end

    def find_common
      # target for disc 1 is t + 1,
      # target for disc 2 is t + 2,
      # disc 1 should be at position POSITIONS - 1
      # disc 2 should be at position POSITIONS - 2
    end
  end
end
