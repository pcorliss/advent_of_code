require 'set'
require '../lib/grid.rb'

module Advent

  class Assembly
    attr_accessor :debug
    attr_reader :instructions, :registers, :pos

    def initialize(input)
      @debug = false
      @registers = {
        a: 0,
        b: 0,
        c: 0,
        d: 0,
      }
      @pos = 0
      @instructions = input.each_line.map do |line|
        line.chomp!
        comps = line.split(" ")
        comps.map do |c|
          if c =~ /\d+/
            c.to_i
          else
            c.to_sym
          end
        end
      end
    end

    def debug!
      @debug = true
    end

    def interpret(instruction)
      inst, a, b = instruction
      case inst
      when :cpy
        if a.is_a? Symbol
          @registers[b] = @registers[a]
        else
          @registers[b] = a
        end
      when :inc
        @registers[a] += 1
      when :dec
        @registers[a] -= 1
      when :jnz
        if @registers[a] != 0
          @pos += b - 1
        end
      end
      @pos += 1
    end

    def run!
      while @pos < @instructions.length do
        interpret(@instructions[@pos])
      end
    end
  end
end
