require 'set'

module Advent

  class Volt
    attr_reader :volts

    def initialize(input)
      @volts = input.each_line.map { |l| l.chomp.to_i }
    end

    def count_diffs
      last = 0
      diffs = {}
      @volts.sort.each do |v|
        diffs[v - last] ||= 0
        diffs[v - last] += 1
        last = v
      end
      diffs[3] += 1
      diffs
    end
  end
end
