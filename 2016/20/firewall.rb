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
      i = 0
      while num != prev_num do
        prev_num = num
        @rules.each do |rule|
          if rule.include? num
            num = rule.last + 1
          end
        end
        i += 1
      end
      puts "Loops: #{i}" if @debug
      num
    end

    def highest
      num = 2**32 - 1
      prev_num = 0
      i = 0
      while num != prev_num do
        prev_num = num
        @rules.each do |rule|
          if rule.include? num
            num = rule.first - 1
          end
        end
        i += 1
      end
      puts "Loops: #{i}" if @debug
      num
    end

    def allowed_count(upper)
      num = 0
      count = 0
      r = @rules.sort_by(&:last)

      while num <= upper do
        allowed = r.all? do |rule|
          if rule.include? num
            num = rule.last + 1
            false
          else
            true
          end
        end
        if allowed
          num += 1
          count += 1
        end
      end

      count
    end
  end
end
