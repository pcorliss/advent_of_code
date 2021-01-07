require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Tractor
    attr_accessor :debug
    attr_reader :program, :grid, :max_x, :max_y

    def initialize(input)
      @debug = false
      @program = Advent::IntCode.new(input)
      @grid = Grid.new
    end

    def scan_cell(x, y)
      return nil if x < 0 || y < 0
      return @grid[x,y] if @grid[x,y]
      p = @program.deepclone
      p.program_input = x
      p.program_input = y
      p.run!
      @grid[x,y] = p.output
    end

    def scan(beg, fin)
      (beg[0]..fin[0]).each do |x|
        (beg[1]..fin[1]).each do |y|
          scan_cell(x, y)
        end
      end
      # puts @grid.render if @debug
    end

    def find_start
      width = 1
      loop do
        scan([0,0],[width,width])
        # puts "Scanning: #{width}" if @debug
        # puts @grid.render if @debug
        cells = @grid.cells.select { |cell, val| val == 1 && cell != [0,0] }
        if !cells.empty?
          start = cells.min_by { |cell, val| cell[0] + cell[1] }
          @max_x ||= start.first
          @max_y ||= start.first
          return start.first
        end
        width += 1
      end
    end

    def expand_edge
      find_start unless @max_x && @max_y
      x, y = @max_x
      scan(@max_x, [x + 1, y + 1])
      @max_x = [[x+1,y], [x+1,y+1], [x,y+1]].find { |pos| @grid[pos] == 1 } || @max_x

      x, y = @max_y
      scan(@max_y, [x + 1, y + 1])
      @max_y = [[x+1,y], [x+1,y+1], [x,y+1]].reverse.find { |pos| @grid[pos] == 1 } || @max_y
    end

    def find_box(dim)
      i = 0
      dim -= 1
      while i < 10_000 do
        find_start unless @max_x && @max_y
        x, y = @max_x
        boundaries = [
          scan_cell(x - dim, y),
          scan_cell(x, y - dim),
          scan_cell(x - dim, y - dim),
        ]
        if boundaries.all? { |val| val == 1 }
          return [x-dim, y]
        end

        x, y = @max_y
        boundaries = [
          scan_cell(x + dim, y),
          scan_cell(x, y - dim),
          scan_cell(x + dim, y - dim),
        ]
        if boundaries.all? { |val| val == 1 }
          return [x, y - dim]
        end

        expand_edge
        # puts "#{i}\n#{@grid.render}" if @debug && i % 50 == 0
        i += 1
      end
    end

    def debug!
      @debug = true
    end
  end
end
