require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Duet
    attr_accessor :debug
    attr_reader :pos, :instructions, :last_sound, :registers

    def initialize(input)
      @debug = false
      @pos = 0
      @halt = false
      @registers = Hash.new(0)
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
      case inst
      when :snd
        @last_sound = @registers[a]
      when :set
        @registers[a] = b
      when :add
        @registers[a] += b
      when :mul
        @registers[a] *= b
      when :mod
        @registers[a] %= b
      when :rcv
        unless @registers[a].zero?
          @registers[a] = @last_sound
          @halt = true
        end
      when :jgz
        @pos += b - 1 if @registers[a] > 0
      end
      @pos += 1
      puts "#{@pos} - #{inst}, #{a}, #{b}, - #{@registers}" if @debug
    end

    def halt?
      @halt || @pos < 0 || @pos > @instructions.length
    end

    def run!
      until halt? do
        run_inst(*@instructions[@pos])
      end
    end
  end
end
