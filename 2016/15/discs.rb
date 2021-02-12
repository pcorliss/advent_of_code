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
      @discs.map do |disc, positions, start|
        (start + t) % positions
      end
    end

    def target_positions
      @discs.map do |disc, positions, start|
        (positions - disc) % positions
      end
    end

    def find_common
      target = target_positions
      t = 0
      until target == position_at(t) do
        puts "#{t} #{target} #{position_at(t)}" if @debug && t % 10000 == 0 
        t += 1
      end
      t
    end
  end
end
