require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Spiral
    attr_accessor :debug
    attr_reader :square, :grid

    def initialize(input)
      @debug = false
      @square = input.to_i
      @grid = Grid.new
    end

    def debug!
      @debug = true
    end

    def find_shell_old(sq)
      i = 0
      loop do
        squared = (i*2+1)**2
        return i if sq <= squared
        i += 1
        return nil if i > 1000
      end
    end

    def find_shell(sq)
      shell = Math.sqrt(sq - 1).to_i
      (shell + 1) / 2
    end

    def get_pos_old(sq)
      shell = find_shell_old(sq)

      pos = [shell, -shell]
      dir_arr = [1, -1, -1, 1]
      dir = dir_arr.pop
      axis = 1
      i = 0
      start_of_shell = ((shell - 1)*2 + 1)**2 + 1
      puts "Shell: #{shell} Pos: #{pos} Range: #{(start_of_shell...sq)}" if @debug
      (start_of_shell..sq).each do |s|
        pos[axis] += dir
        puts "s: #{s} i: #{i} Pos: #{pos} Axis: #{axis} Dir: #{dir}" if @debug
        i += 1
        if i % (shell * 2) == 0
          axis = (axis + 1) % 2
          dir = dir_arr.pop
          puts "New Dir: #{dir} Axis: #{axis}" if @debug
        end
      end
      pos
    end

    def get_pos(sq)
      shell = find_shell(sq)
      pos = [shell, -shell]
      return pos if shell == 0

      last_elem_in_shell = (shell * 2 + 1)**2
      distance_to_last = last_elem_in_shell - sq
      distance_to_corner = shell * 2

      sides = distance_to_last / distance_to_corner
      rem = distance_to_last % distance_to_corner

      axis = 0
      dir_arr = [-1, 1, 1, -1]
      dir_count = 0

      sides.times do |i|
        pos[axis] += dir_arr[dir_count] * distance_to_corner
        axis += 1
        axis %= 2
        dir_count += 1
      end

      pos[axis] += dir_arr[dir_count] * rem

      pos
    end

    def gen_grid(inp)
      @grid[0,0] ||= 1
      axis = 0
      dir_arr = [1, -1, -1, 1]
      dir_count = 0
      dir = dir_arr[dir_count]
      shell = find_shell(2)
      i = 1
      pos = [0,0]
      loop do
        i += 1
        shell = find_shell(i)
        if (pos[axis] + dir).abs > shell
          axis += 1
          axis %= 2
          dir_count += 1
          dir = dir_arr[dir_count % dir_arr.length]
          puts "New Dir: #{dir} Axis: #{axis}" if @debug
        end
        pos[axis] += dir
        @grid[pos] ||= @grid.neighbors(pos, true).sum(&:last)
        puts "Shell: #{shell} Pos: #{pos} Sum: #{@grid[pos]}" if @debug
        puts "#{@grid.render(1)}" if @debug
        return @grid[pos] if @grid[pos] > inp
        raise "Too many iterations!!! #{i}" if i > 1000
      end
    end
  end
end
