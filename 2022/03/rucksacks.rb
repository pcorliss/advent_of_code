require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Rucksacks
    attr_accessor :debug
    attr_reader :sacks

    def initialize(input)
      @debug = false
      @sacks = []
      input.each_line do |line|
        @sacks << line.chomp.split('')
      end
    end

    def debug!
      @debug = true
    end

    def common(sack)
      half = sack.length / 2
      set = Set.new sack.first(half)
      sack.last(half).each do |item|
        return item if set.include? item
      end
      return nil
    end

    def priority_sum
      sacks.map {|s| common(s) }.map do |item|
        ord = item.ord
        if ord > 96
          ord - 96
        else
          ord - 64 + 26
       end
      end.sum
    end
  end
end
