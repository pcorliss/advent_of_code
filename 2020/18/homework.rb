require 'set'

module Advent

  class Homework
    attr_reader :expressions

    def initialize(input, precedence = nil)
      @expressions = input.each_line.map(&:chomp)
      @precedence = precedence
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
      if @precedence
        new_expr = []
        idx = 0
        while idx < expr.length do
          e = expr[idx]
          if e == @precedence
            first_term = new_expr.pop
            second_term = expr[idx + 1]
            first_term = evaluate(first_term) if first_term.is_a? Array
            second_term = evaluate(second_term) if second_term.is_a? Array
            new_expr << first_term + second_term if e == '+'
            new_expr << first_term * second_term if e == '*'
            idx += 1
          else
            new_expr << e
          end
          idx += 1
        end
        expr = new_expr
      end

      acc = 0
      operator = nil
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
