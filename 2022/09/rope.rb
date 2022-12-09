require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Rope
    attr_accessor :debug
    attr_reader :instructions, :head, :tail, :tracer

    def initialize(input)
      @debug = false
      @instructions = input.each_line.map do |line|
        line.chomp!
        dir, quant = line.split(' ')
        [dir.to_sym, quant.to_i]
      end

      @head = [0,0]
      @tail = [0,0]
      @tracer = Set.new([tail.clone])
    end

    def debug!
      @debug = true
    end

    DIRECTIONS = {
      L: [-1, 0], # Left
      R: [ 1, 0], # Right
      U: [ 0,-1], # Up
      D: [ 0, 1], # Down
    }

    def adjacent?(h, t)
      (h[0] - t[0]).abs <= 1 &&
      (h[1] - t[1]).abs <= 1
    end

    def move_all!
      instructions.each do |inst|
        move!(inst)
      end
    end

    def move!(instruction)
      dir, dist = instruction
      x, y = DIRECTIONS[dir]
      dist.times do |i|
        head[0] += x
        head[1] += y
        unless adjacent?(head, tail)
          x_diff = head[0] - tail[0]
          y_diff = head[1] - tail[1]
          puts "Diff: #{[x_diff, y_diff]}" if debug

          # Makes the math work below
          x_diff = -1 if x_diff.negative?
          y_diff = -1 if y_diff.negative?

          tail[0] += [x_diff, 1].min
          tail[1] += [y_diff, 1].min

          tracer.add tail.clone
        end

        puts "Head: #{head} Tail: #{tail}" if debug
      end
    end

    def visited
      move_all!
      tracer.count
    end
  end
end
