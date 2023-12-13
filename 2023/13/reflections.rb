require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Reflections
    attr_accessor :debug
    attr_reader :grids

    def initialize(input)
      @debug = false
      @grids = []
      input.split("\n\n").each do |grid_input|
        @grids << Grid.new(grid_input)
      end
    end

    def debug!
      @debug = true
    end

    # returns the reflection point or nil if there is none
    def reflection_point(nums)
      puts "Nums: #{nums.inspect}" if @debug
      (nums.length - 1).times do |idx|
        left, right = nums[0..idx], nums[idx+1..-1]
        puts "Left: #{left.inspect} Right: #{right.inspect}" if @debug
        match = true
        right.each_with_index do |r, i|
          break if i > left.length - 1
          l = left[left.length - i - 1]
          puts "\tIdx: #{i} Comp: #{l}:#{r}" if @debug
          if l != r
            match = false
            break
          end
        end
        puts "Match?: #{match}" if @debug
        return idx + 1 if match
      end

      nil
    end

    def reflection(grid)
      cols = []
      rows = []

      grid.width.times do |x|
        grid.height.times do |y|
          if grid[x,y] == '#'
            cols[x] ||= 0
            cols[x] += (1 << y)
            rows[y] ||= 0
            rows[y] += (1 << x)
          end
        end
      end

      # puts "Cols: #{cols.inspect}" if @debug
      # puts "Rows: #{rows.inspect}" if @debug
      # puts "Cols: #{cols.map {|c| c.to_s(2)}}" if @debug
      # puts "Rows: #{rows.map {|c| c.to_s(2)}}" if @debug
      c_reflect = reflection_point(cols)
      return [:y, c_reflect] if c_reflect

      r_reflect = reflection_point(rows)
      return [:x, r_reflect] if r_reflect

      nil
    end

    def reflection_sum
      @grids.sum do |grid|
        dir, point = reflection(grid)
        point *= 100 if dir == :x
        point
      end
    end
  end
end
