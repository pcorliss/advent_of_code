require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Falling
    attr_accessor :debug
    attr_reader :grid, :max_y, :floor

    def initialize(input, floor = false)
      @debug = false
      @grid = Grid.new
      @max_y = 0
      input.each_line do |line|
        line.chomp!

        coords = line.split(' -> ').map {|c| c.split(',').map(&:to_i) }
        start = coords.shift
        coords.each do |coord|
          start_x, start_y = start
          end_x, end_y = coord

          amp = nil
          dir = nil
          if start_x == end_x
            amp = (end_y - start_y)
            dir = [0, amp / amp.abs]
          else
            amp = (end_x - start_x)
            dir = [amp / amp.abs, 0]
          end

          # puts "Start: #{start} -> #{coord}"
          # puts "Amp: #{amp} #{dir}"
          (amp.abs + 1).times do |i|
            d_x, d_y = dir
            pos_x, pos_y = start
            pos_x += i*d_x 
            pos_y += i*d_y
            point = [pos_x, pos_y]
            # puts "Point: #{point}"
            @grid[point] = '#'
            @max_y = pos_y if pos_y > @max_y
          end

          @floor = @max_y + 2 if floor
          start = coord
        end
      end
    end

    def no_block_present?(pos_x, pos_y)
      if @floor
        @grid[pos_x, pos_y].nil? && pos_y < @floor
      else
        @grid[pos_x, pos_y].nil?
      end
    end

    SAND = [500,0]
    def drop_sand
      start = SAND
      pos_x, pos_y = start

      return nil unless no_block_present?(pos_x, pos_y)

      settled = false
      i = 0
      until settled do
        puts "Testing #{[pos_x, pos_y]} - #{@grid[[pos_x, pos_y]]}" if @debug
        if no_block_present?(pos_x, pos_y + 1)
          pos_y += 1
        elsif no_block_present?(pos_x - 1, pos_y + 1)
          pos_x -= 1
          pos_y += 1
        elsif no_block_present?(pos_x + 1, pos_y + 1)
          pos_x += 1
          pos_y += 1
        else
          settled = true
        end
        puts "Floor Check: #{pos_y > @max_y} && #{!@floor}" if @debug
        return nil if pos_y > @max_y && !@floor
        i += 1
        raise "Too many iterations" if i > 1000
      end
      @grid[[pos_x, pos_y]] = 'o'
      return [pos_x, pos_y]
    end

    def fill_sand!
      i = 0
      while drop_sand do
        i += 1
      end
      i
    end

    def debug!
      @debug = true
    end
  end
end
