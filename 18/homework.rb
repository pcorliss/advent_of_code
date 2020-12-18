require 'set'

module Advent

  class Homework
    attr_reader :expressions

    def initialize(input)
      @expressions = input.each_line.map(&:chomp)
    end

    def parse(expr)
      acc = []
      arr_stack = [acc]
      expr.each_char do |char|
        case char
        when /\d/
          acc << char.to_i
        when /[\+\*]/
          acc << char
        when '('
          arr_stack << []
          acc = arr_stack.last
        when ')'
          arr = arr_stack.pop
          acc = arr_stack.last
          acc << arr
        end
      end
      acc
    end

    def evaluate(expr)
      acc = 0
      operator = nil
      expr = parse(expr) if expr.is_a?(String)
      expr.each do |e|
        if e.is_a? String
          operator = e
        elsif e.is_a? Array
          eve = evaluate(e)
          acc = acc * eve if operator == '*'
          acc = acc + eve if operator == '+'
          acc = eve if operator.nil?
        else
          acc = acc * e if operator == '*'
          acc = acc + e if operator == '+'
          acc = e if operator.nil?
        end
      end
      acc
    end

    def sum
      @expressions.map {|e| evaluate(e)}.sum
    end
  end
end
