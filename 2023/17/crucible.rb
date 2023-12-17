require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

require 'fc'

module Advent

  class Crucible
    attr_accessor :debug
    attr_reader :grid

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @grid.cells.each do |cell, val|
        @grid[cell] = val.to_i
      end
    end

    def debug!
      @debug = true
    end

    N = [ 0,-1]
    S = [ 0, 1]
    W = [-1, 0]
    E = [ 1, 0]
    L = 0
    R = 1

    DIR_MAP = {
      N => [W, E],
      S => [E, W],
      W => [S, N],
      E => [N, S],
    }

    DIR_RENDER_MAP = {
      N => '^',
      S => 'v',
      W => '<',
      E => '>',
    }

    def render_path(path)
      g = Grid.new
      g.cells = @grid.cells.dup
      path.each do |x, y, dx, dy, loss, sc, p|
        # puts "  #{x},#{y} #{dx},#{dy} #{loss} #{straight_counter} #{path}"
        g[x,y] = DIR_RENDER_MAP[[dx,dy]]
      end
      g.render
    end

    def path_find
      # Pos 0,0; Dir East; HeatLoss: 0, Straight counter: 0
      start = [0,0,1,0,0,0, []]
      dest = [@grid.width-1, @grid.height-1]

      candidates = [start]
      q = FastContainers::PriorityQueue.new(:min)
      q.push(start, dest.sum)

      best_loss_map = {[0,0,1,0] => 0}
      best_finish = nil
      best_finish_path = nil

      b = true

      until q.empty? do
        puts "Q: #{q.count}, TopK: #{q.top_key}, Top: #{q.top.first(5)}" if @debug
        x, y, dx, dy, loss, straight_counter, path = q.pop

        # if @debug && b && [x,y] == [2,0] && [dx, dy] == E
        #   # binding.pry
        #   b = false
        # end

        # Post Pruning
        if [x,y] == dest
          if best_finish.nil? || loss < best_finish
            best_finish = loss 
            best_finish_path = path
            puts "New Best Finish: #{best_finish}, Q Count: #{q.count}" if @debug
          end
          next
        end

        next if best_finish && loss >= best_finish
        # next if it's not possible to make best finish work given avg loss 

        [L, R, :S].each do |turn|
          if turn == :S
            next if straight_counter >= 3
            ndx, ndy = dx, dy
            new_straight_counter = straight_counter + 1
          else
            ndx, ndy = DIR_MAP[[dx,dy]][turn]
            new_straight_counter = 1
          end

          new_pos = [x + ndx, y + ndy]
          puts "  Turn: #{turn}: Pos: #{new_pos}, Dir:#{ndx},#{ndy}" if @debug
          # PrePrune if off grid
          next unless @grid[new_pos]
          new_loss = @grid[new_pos] + loss
          # PrePrune if we've already been here and had a better loss
          # Likely need to only prune on new_pos + dir
          pos_and_dir_and_step = [*new_pos, ndx, ndy, new_straight_counter]
          # if @debug && pos_and_dir_and_step == [3,1,1,0,1] #&& new_loss == 15
          #   binding.pry
          # end
          # if @debug && pos_and_dir_and_step == [4,1,1,0,2] #&& new_loss == 15
          #   binding.pry
          # end
          next if best_loss_map[pos_and_dir_and_step] && best_loss_map[pos_and_dir_and_step] <= new_loss
          best_loss_map[pos_and_dir_and_step] = new_loss
          puts "    New Loss: #{new_loss}" if @debug
          nx, ny = new_pos
          step = [nx, ny, ndx, ndy, new_loss, new_straight_counter]
          new_path = path.dup << step.dup
          step << new_path 
          q.push(step, dest.sum - new_pos.sum + new_loss)
        end
      end
    
      puts "Path:\n#{render_path(best_finish_path)}" if @debug
      # binding.pry if @debug

      best_finish
    end
  end
end
