require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Turing
    attr_accessor :debug
    attr_reader :tape, :cursor, :instructions, :diag, :state

    def initialize(input)
      @debug = false
      @tape = Hash.new(0)
      @cursor = 0
      @instructions = {}
      @state = 'A'
      @diag = 0
      state = nil
      current = nil
      input.each_line do |line|
        line.chomp!
        if line =~ /Perform a diagnostic checksum after (\d+) steps./
          @diag = $1.to_i
        elsif line =~ /In state (\w):/
          state = $1
          @instructions[state] ||= []
        elsif line =~ /If the current value is (\d+)/
          current = $1.to_i
          @instructions[state][current] ||= []
        elsif line =~ /Write the value (\d+)./
          @instructions[state][current] << [:write, $1.to_i]
        elsif line =~ /Move one slot to the (right|left)./
          move = $1 == 'right' ? 1 : -1
          @instructions[state][current] << [:move, move]
        elsif line =~ /Continue with state (\w)./
          @instructions[state][current] << [:state, $1]
        else
          # puts "Can't find line #{line}"
        end
      end
    end

    def debug!
      @debug = true
    end

    def run!(n = @diag)
      n.times do |i|
        val = @tape[@cursor]
        @instructions[@state][val].each do |a, b|
          case a
          when :write
            @tape[@cursor] = b
          when :move
            @cursor += b
          when :state
            @state = b
          end
        end
      end
    end

    def checksum
      @tape.values.count { |v| v == 1 }
    end
  end
end
