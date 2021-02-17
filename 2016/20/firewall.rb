require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Firewall
    attr_accessor :debug
    attr_reader :rules

    def initialize(input)
      @debug = false
      @rules = input.each_line.map do |line|
        line.chomp!
        a, b = line.split('-')
        (a.to_i..b.to_i)
      end
    end

    def debug!
      @debug = true
    end

    def lowest
      num = 0
      prev_num = -1
      while num != prev_num do
        prev_num = num
        @rules.each do |rule|
          if rule.include? num
            num = rule.last + 1
          end
        end
      end
      num
    end
  end
end
