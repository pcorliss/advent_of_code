require 'set'

module Advent

  class Volt
    attr_reader :volts

    def initialize(input)
      @volts = input.each_line.map { |l| l.chomp.to_i }
      @volts.sort!
    end

    def count_diffs
      last = 0
      diffs = {}
      @volts.each do |v|
        diffs[v - last] ||= 0
        diffs[v - last] += 1
        last = v
      end
      diffs[3] += 1
      diffs
    end

    def arrangements
      nodes = {}
      nodes[0] = 1
      @volts.each do |v|
        nodes[v] ||= 0
        nodes[v] += nodes[v - 3] || 0
        nodes[v] += nodes[v - 2] || 0
        nodes[v] += nodes[v - 1] || 0
      end
      nodes
    end
  end
end
