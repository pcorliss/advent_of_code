require 'set'
require '../lib/grid.rb'

module Advent

  class Circuit
    attr_accessor :debug, :cache
    attr_reader :instructions

    def initialize(input)
      @debug = false
      @instructions = input.lines.map(&:chomp).inject({}) do |acc, line|
        stuff, target = line.split(' -> ')
        args = stuff.split(' ')
        # binding.pry if target == 'a'
        if args.count == 1
          a = args.first
          a = a.to_i if a =~ /^\d+$/
          acc[target] = [a]
        elsif args.count == 2
          inst, a = args
          a = a.to_i if a =~ /^\d+$/
          acc[target] = [inst.downcase.to_sym, a]
        elsif args.count == 3
          a, inst, b = args
          a = a.to_i if a =~ /^\d+$/
          b = b.to_i if b =~ /^\d+$/
          acc[target] = [inst.downcase.to_sym, a, b]
        else
          raise "Unrecognized instruction: #{line}-#{args}-#{target}"
        end
        acc
      end
      @cache = {}
    end

    def debug!
      @debug = true
      # binding.pry
    end

    def resolve(target)
      return @cache[target] if @cache[target]
      inst, a, b = @instructions[target]
      return inst if inst.is_a? Integer
      return resolve(inst) if inst.is_a? String
      a = resolve(a) if a.is_a? String
      b = resolve(b) if b.is_a? String

      @cache[target] = case inst
      when :not
        (~a) % 65536
      when :and
        a & b
      when :or
        a | b
      when :lshift
        a << b
      when :rshift
        a >> b
      else
        raise "Unhandled Instruction"
      end

      @cache[target]
    end
  end
end
