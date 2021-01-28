require 'set'
require '../lib/grid.rb'

module Advent

  class Liters
    attr_accessor :debug
    attr_reader :containers

    def initialize(input)
      @debug = false
      @containers = input.lines.map(&:chomp).map(&:to_i)
    end

    def debug!
      @debug = true
    end

    def combos(target)
      acc = []
      (1..@containers.length).each do |size|
        acc.concat(@containers.combination(size).select { |combo| combo.sum == target })
      end
      acc
    end
  end
end
