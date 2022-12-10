require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Rope
    attr_accessor :debug
    attr_reader :instructions, :knots, :head, :tail, :tracer

    def initialize(input, knots = 2)
      @debug = false
      @instructions = input.each_line.map do |line|
        line.chomp!
        dir, quant = line.split(' ')
        [dir.to_sym, quant.to_i]
      end


      @knots = knots.times.map { |i| [0,0] }

      @head = @knots.first
      @tail = @knots.last

      @tracer = Set.new([[0,0]])
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
        @knots.each_with_index do |knot, idx|
          next if idx == 0
          leader = @knots[idx - 1]
          follower = knot
          unless adjacent?(leader, follower)
            x_diff = leader[0] - follower[0]
            y_diff = leader[1] - follower[1]
            puts "Diff: #{[x_diff, y_diff]}" if debug

            # Makes the math work below
            x_diff = -1 if x_diff.negative?
            y_diff = -1 if y_diff.negative?

            follower[0] += [x_diff, 1].min
            follower[1] += [y_diff, 1].min
          end
        end

        tracer.add tail.clone
        puts "Head: #{head} Tail: #{tail}" if debug
      end
    end

    def visited
      move_all!
      tracer.count
    end
  end
end
