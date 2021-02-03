require 'set'
require '../lib/grid.rb'

module Advent

  class Machine
    attr_accessor :debug, :instructions, :register

    def initialize(input)
      @debug = false
      @instructions = input.lines.map do |line|
        line.chomp!
        puts "Line: #{line}" if @debug
        ab, c = line.split(',')
        a, b = ab.split(' ')
        if c.nil? && b =~ /^[\+\-]\d+$/
          [a.to_sym, b.to_i, 0]
        else
          [a.to_sym, b.to_sym, c.to_i]
        end
      end
      @register = {
        a: 0,
        b: 0,
      }
    end

    def debug!
      @debug = true
    end

    def run!
      i = 0
      while i < @instructions.length do
        inst, reg, mod = @instructions[i]
        case inst
        when :inc
          @register[reg] += 1
        when :hlf
          @register[reg] /= 2
        when :tpl
          @register[reg] *= 3
        when :jmp
          i += reg - 1
        when :jie
          i += mod - 1 if @register[reg].even?
        when :jio
          i += mod - 1 if @register[reg] == 1
        end
        i += 1
      end
      @register.values
    end
  end
end
