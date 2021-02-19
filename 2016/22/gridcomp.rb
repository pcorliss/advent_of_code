require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Gridcomp
    attr_accessor :debug
    attr_reader :nodes

    FS_REGEX = /^\/dev\/grid\/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)%$/

    def initialize(input)
      @debug = false
      @nodes = []
      input.each_line do |line|
        line.chomp!
        if line =~ FS_REGEX
          @nodes << [[$1.to_i, $2.to_i], $3.to_i, $4.to_i]
        end
      end
    end

    def debug!
      @debug = true
    end

    POS = 0
    SIZE = 1
    USED = 2

    def viable_pair?(a, b)
      return false if a[USED] == 0
      return false if a[POS] == b[POS]
      return false if a[USED] > (b[SIZE] - b[USED])
      true
    end

    def count_viable_pairs
      count = 0
      @nodes.combination(2).each do |combo|
        count += 1 if viable_pair?(*combo)
        count += 1 if viable_pair?(*combo.reverse)
      end
      count
    end
  end
end
