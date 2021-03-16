require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Coproc
    attr_accessor :debug
    attr_reader :pos, :instructions, :last_sound, :registers, :inst_count

    def initialize(input)
      @debug = false
      @pos = 0
      @halt = false
      @registers = Hash.new(0)
      @inst_count = Hash.new(0)
      @instructions = input.each_line.map do |line|
        line.chomp!
        line.split(' ').map do |segment|
          if segment =~ /^[a-z]*$/
            segment.to_sym
          else
            segment.to_i
          end
        end
      end
    end

    def debug!
      @debug = true
    end

    def run_inst(inst, a, b = nil)
      b = @registers[b] if b.is_a?(Symbol)
      @inst_count[inst] += 1
      case inst
      when :set
        @registers[a] = b
      when :mul
        @registers[a] *= b
      when :sub
        @registers[a] -= b
      when :jnz
        a = @registers[a] if a.is_a? Symbol
        @pos += b - 1 if !a.zero?
      end
      @pos += 1
      puts "#{@pos} - #{inst}, #{a}, #{b}, - #{@registers}" if @debug
      # binding.pry if @debug
    end

    def halt?
      @pos >= @instructions.length
    end

    def run!
      i = 0
      until halt? do
        run_inst(*@instructions[@pos])
        puts "#{i + 1} - #{@pos} - #{@registers}" if i % 1_000_000 == 99_999
        i += 1
      end
    end
  end
end
