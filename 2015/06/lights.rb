require 'set'
require '../lib/grid.rb'

module Advent

  class Lights
    attr_accessor :debug
    attr_reader :instructions, :grid

    def initialize(input)
      @debug = false
      @instructions = input.lines.map do |line|
        line.chomp!
        op = nil
        start = nil
        finish = nil
        op = :on if line.start_with? 'turn on'
        op = :off if line.start_with? 'turn off'
        op = :toggle if line.start_with? 'toggle'
        if line =~ / (\d+),(\d+) through (\d+),(\d+)$/
          start = [$1, $2].map(&:to_i)
          finish = [$3, $4].map(&:to_i)
        end
        [op, start, finish]
      end
      @grid = Grid.new
    end

    OP_MAP = {
      :on => [:|, 1],
      :off => [:&, 0],
      :toggle => [:^, 1],
    }

    def apply!
      @instructions.each do |op_sym, start, finish|
        op, val = OP_MAP[op_sym]
        @grid.box!(start, finish, val, op)
        puts "Applied #{op_sym}, #{start}, #{finish}" if @debug
      end
    end

    def debug!
      @debug = true
    end
  end
end
