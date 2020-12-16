require 'set'

module Advent
  class Ticket
    attr_reader :ticket, :tickets, :rules, :fields

    def initialize(input)
      @ticket = []
      @tickets = []
      @rules = []
      @fields = {}

      your = false
      nearby = false

      input.each_line do |line|
        l = line.chomp
        case l
        when ""
        when "your ticket:"
          your = true
        when "nearby tickets:"
          nearby = true
        else
          if nearby
            @tickets << l.split(",").map(&:to_i)
          elsif your
            @ticket = l.split(",").map(&:to_i)
          else
            field, rs = l.split(": ")
            rs = rs.split(" or ")
            rs.map! do |range|
              start, finish = range.split("-")
              (start.to_i..finish.to_i)
            end
            @rules.concat rs
            @fields[field] = rs
          end
        end
      end
    end

    def invalid_nums(nums)
      nums.select do |n|
        !@rules.any? { |f| f.include? n }
      end
    end

    def sum
      tickets.map do |t|
        invalid_nums(t)
      end.flatten.inject(:+)
    end
  end
end
