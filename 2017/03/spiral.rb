require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Spiral
    attr_accessor :debug
    attr_reader :square

    def initialize(input)
      @debug = false
      @square = input.to_i
    end

    def debug!
      @debug = true
    end

    def find_shell(sq)
      i = 0
      loop do
        squared = (i*2+1)**2
        return i if sq <= squared
        i += 1
        return nil if i > 1000
      end
    end

    def get_pos(sq)
      shell = find_shell(sq)

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
  end
end
