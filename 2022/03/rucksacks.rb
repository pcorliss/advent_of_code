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

    def common_group_item(a, b, c)
      a_set = Set.new a
      b_set = Set.new b
      c_set = Set.new c 

      a.intersection(b).intersection(c).first
    end

    def priority(item)
      ord = item.ord
      if ord > 96
        ord - 96
      else
        ord - 64 + 26
      end
    end

    def priority_sum
      sacks.map {|s| common(s) }.map do |item|
        priority(item)
      end.sum
    end

    def priority_sum_groups
      sacks.each_slice(3).sum do |group|
        priority(common_group_item(*group))
      end
    end
  end
end
