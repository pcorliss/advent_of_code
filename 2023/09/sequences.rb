require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Sequences
    attr_accessor :debug
    attr_reader :sequences

    def initialize(input)
      @debug = false
      @sequences = input.lines.map do |line|
        line.split.map(&:to_i)
      end
    end

    def debug!
      @debug = true
    end

    def diffs(sequence)
      sequence.each_cons(2).map do |a, b|
        b - a
      end 
    end

    def next_number(sequence)
      working = [sequence.dup]
      puts "Working A: #{working.inspect}" if @debug
      until working.last.all?(&:zero?) do
        working << diffs(working.last)
        puts "Working B: #{working.inspect}" if @debug
      end

      while working.length > 1 do
        puts "Working C: #{working.inspect}" if @debug
        seq = working.pop
        working.last << working.last.last + seq.last
      end

      puts "Working D: #{working.inspect}" if @debug
      working.last.last
    end

    def sum_next_number
      @sequences.sum do |seq|
        next_number(seq)
      end
    end
  end
end
