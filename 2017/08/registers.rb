require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Registers
    attr_accessor :debug
    attr_reader :instructions, :registers

    def initialize(input)
      @debug = false
      @registers = {}
      @instructions = input.each_line.map do |line|
        line.chomp!
        inst = line.split.map do |e|
          e =~ /^[\-\d]+$/ ? e.to_i : e.to_sym
        end

        inst.each_slice(2) do |even, odd|
          @registers[even] ||= 0 if even.is_a? Symbol
        end

        inst
      end
    end

    def debug!
      @debug = true
    end

    def inc(reg, num)
      @registers[reg] += num
    end

    def dec(reg, num)
      inc(reg, -num)
    end

    def run_inst(inst)
      reg, op, num, _, a, meth, b = inst
      self.__send__(op, reg, num) if @registers[a].__send__(meth, b)
    end

    def run!
      max = nil
      @instructions.each do |inst|
        run_inst(inst)
        new_max = @registers.values.max
        max = new_max if max.nil? || max < new_max
      end
      max
    end
  end
end
