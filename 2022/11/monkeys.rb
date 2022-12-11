require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Monkey
    attr_accessor :items, :operator, :operand, :div, :throw_test
    attr_reader :inspected

    def initialize
      @throw_test = {}
      @inspected = 0
    end

    def operate(input)
      if operator == :old
        input.__send__(operand, input)
      else
        input.__send__(operand, operator)
      end
    end

    def throw(val)
      @inspected += 1
      throw_test[val % @div == 0]
    end
  end

  class Monkeys
    attr_accessor :debug, :no_worries
    attr_reader :monkeys

    def initialize(input)
      @debug = false
      @monkeys = []
      input.each_line do |line|
        line.chomp!
        line.strip!
        if line.start_with? 'Monkey'
          @monkeys << Monkey.new
        elsif line.start_with? 'Starting items:'
          x, items = line.split(':')
          @monkeys.last.items = items.split(',').map(&:to_i)
        elsif line.start_with? 'Operation:'
          x, operation = line.split('=')
          a, operator, b = operation.split(' ')
          @monkeys.last.operand = operator.to_sym
          @monkeys.last.operator = b == 'old' ? :old : b.to_i
        elsif line.start_with? 'Test: '
          @monkeys.last.div = line.split(' ').last.to_i
        elsif line.start_with? 'If '
          x, bool, x, x, x, monkey = line.split(' ')
          @monkeys.last.throw_test[bool == 'true:'] = monkey.to_i
        end
      end
      @mega_divisor = @monkeys.map(&:div).inject(:*)
      @no_worries = false
    end

    def debug!
      @debug = true
    end

    def process_monkey!(monkey)
      monkey.items.each do |item|
        newval = monkey.operate(item)
        if @no_worries
          newval %= @mega_divisor
        else
          newval /= 3
        end
        newmonkey = monkey.throw(newval)
        @monkeys[newmonkey].items << newval
      end
      monkey.items = []
    end

    def process_round!
      @monkeys.each do |monkey|
        process_monkey!(monkey)
      end
    end

    def monkey_business
      @monkeys.map(&:inspected).sort.last(2).inject(:*)
    end
  end
end
