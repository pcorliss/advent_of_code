require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Wasteland
    attr_accessor :debug
    attr_reader :directions, :mapping

    def initialize(input)
      @debug = false
      lines = input.lines
      direction_line = input.lines.shift
      @directions = direction_line.chomp.split('').map(&:to_sym)
      @mapping = {}
      lines.each do |line|
        if line =~ /^(\w+) = \((\w+), (\w+)\)$/
          key = $1.to_sym
          @mapping[key] = [$2.to_sym, $3.to_sym]
        end
      end
    end

    def debug!
      @debug = true
    end

    def steps
      count = 0
      current = :AAA
      until current == :ZZZ do
        dir = @directions[count % @directions.length]
        count += 1
        current = @mapping[current][dir == :L ? 0 : 1]
      end
      count
    end
  end
end
