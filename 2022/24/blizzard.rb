require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'deep_clone'
require 'fc'

module Advent

  class Blizzard
    attr_accessor :debug
    attr_reader :grid, :exp, :goal, :blizzards

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @exp = @grid.find_all('.').find {|cell| cell.last == 0 }
      @goal = @grid.find_all('.').max_by {|cell| cell.last }
      @blizzards = @grid.cells.map do |cell, val|
        [cell, val] if ['>','<','v','^'].include? val
      end.compact
      @empty_grid = Grid.new
      @grid.cells.each do |cell, val|
        @empty_grid[cell] = val == '#' ? '#' : '.'
      end
      @max_cell = @grid.cells.max_by {|cell, val| cell[0] * cell[1] }.first
      @tick = [@grid]
      @blizzard_state = [@blizzards]
    end

    def debug!
      @debug = true
    end

    BLIZZ_DELTA = {
      '>' => [ 1, 0],
      '<' => [-1, 0],
      'v' => [ 0, 1],
      '^' => [ 0,-1],
    }

    def tick(minute = @tick.length)
      return @tick[minute] if @tick[minute]

      tick(minute-1) if @blizzard_state[minute-1].nil?

      new_grid = DeepClone.clone(@empty_grid)
      new_blizzard_state = []

      max_x, max_y = @max_cell
      @blizzard_state[minute - 1].each do |pos, dir|
        delta_x, delta_y = BLIZZ_DELTA[dir]
        x, y = pos
        new_pos = [x + delta_x, y + delta_y]
        if new_grid[new_pos] == '#'
          new_x, new_y = new_pos
          new_x = 1 if new_x == max_x
          new_x = max_x - 1 if new_x == 0

          new_y = 1 if new_y == max_y
          new_y = max_y - 1 if new_y == 0
          new_pos = [new_x, new_y]
        end

        new_blizzard_state << [new_pos, dir]

        if new_grid[new_pos] == '.'
          new_grid[new_pos] = dir
        elsif new_grid[new_pos].is_a? Numeric
          new_grid[new_pos] += 1
        else
          new_grid[new_pos] = 2
        end
      end

      @blizzard_state[minute] = new_blizzard_state
      @tick[minute] = new_grid
    end

    def distance_to_goal(pos, end_pos)
      pos_x, pos_y = pos
      goal_x, goal_y = end_pos
      (goal_x - pos_x).abs + (goal_y - pos_y).abs
    end

    def score(pos, minute, end_pos)
      # @best_distance ||= {}

      distance = distance_to_goal(pos, end_pos)
      # @best_distance[distance] ||= minute
      # if @best_distance[distance] > minute
      #   @best_distance[distance] = minute
      # end

      # best_score = minute - @best_distance[distance]

      distance + minute #/ 2 #+ v_score / 4 + best_score / 4
    end

    def solve(start_min = 0, start_pos = @exp, end_pos = @goal)
      candidates = FastContainers::PriorityQueue.new(:min)
      candidates.push({minute: start_min, pos: start_pos}, score(start_pos, start_min, end_pos))
      
      best = nil

      visited = Set.new
      visited.add [candidates.first]

      i = 0
      until candidates.empty? do
        candidate = candidates.pop


        # Remove Duplicate States
        next if visited.include? candidate
        visited.add candidate

        # puts "Candidate: #{candidate}" if @debug
        # best calc
        if candidate[:pos] == end_pos
          if best.nil? || candidate[:minute] < best[:minute]
            best = candidate
          end
          next
        end

        distance = distance_to_goal(candidate[:pos], end_pos)

        # Prune paths tht have no hope of yielding an optimal solution
        next if best && distance + candidate[:minute] > best[:minute]


        g = tick(candidate[:minute] + 1)
        # puts "Grid:\n#{g.render}\n" if @debug
        g.neighbors(candidate[:pos]).each do |cell, val|
          if val == '.'
            # puts "New Candidate: #{cell} #{val}" if @debug
            candidates.push(
              {minute: candidate[:minute] + 1, pos: cell},
              score(cell, candidate[:minute] + 1, end_pos)
            )
          end
        end

        # Wait in place
        if g[candidate[:pos]] == '.'
          candidates.push(
            {minute: candidate[:minute] + 1, pos: candidate[:pos]},
            score(candidate[:pos], candidate[:minute] + 1, end_pos)
          )
        end

        i += 1
        if @debug && i % 10_000 == 0
          puts "\tCandidates: #{candidates.count} - Iterations: #{i}"
          puts "\tLast Candidate: #{candidate} Distance: #{distance_to_goal(candidate[:pos], end_pos)}"
          puts "Best: #{best}"
        end
        raise "Too many iterations" if i > 10_000_000
      end

      raise "Unable to find path!!!" if best.nil?
      best[:minute]
    end
  end
end
