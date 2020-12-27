require 'set'

module Advent

  class Cubes
    X = 0
    Y = 1
    Z = 2
    W = 3
    ACTIVE = '#'
    INACTIVE = '.'
    CYCLES = 6

    attr_reader :grid, :cycle

    def initialize(input, dimensions = 3)
      @grid = Set.new
      @cycle = 0
      @dimensions = dimensions

      y = 0
      z = 0
      input.each_line do |line|
        x = 0
        l = line.chomp
        l.each_char do |char|
          if char == ACTIVE
            cube = [x, y, z]
            cube << 0 if dimensions > 3
            @grid.add cube
          end
          x += 1
        end
        y += 1
      end
    end

    def neighbor_coords(coord)
      coords = []
      (-1..1).each do |x|
        (-1..1).each do |y|
          (-1..1).each do |z|
            if @dimensions > 3
              (-1..1).each do |w|
                coords << [coord[X] + x, coord[Y] + y, coord[Z] + z, coord[W] + w] unless x == 0 && y == 0 && z == 0 && w == 0
              end
            else
              coords << [coord[X] + x, coord[Y] + y, coord[Z] + z] unless x == 0 && y == 0 && z == 0
            end
          end
        end
      end
      coords
    end

    def neighbors(coord)
      neighbor_coords(coord).inject([]) do |acc, n|
        acc << n if @grid.include? n
        acc
      end
    end

    def cycle!
      @cycle += 1
      new_grid = Set.new
      # need to create a count hash based on neighbor_coords

      counts = {}
      @grid.each do |cube|
        neighbor_coords(cube).each do |c|
          counts[c] ||= 0
          counts[c] += 1
        end
      end

      counts.each do |cube, count|
        active = @grid.include? cube
        if active
          new_grid.add cube if (count == 2 || count == 3)
        else
          new_grid.add cube if count == 3
        end
      end

      @grid = new_grid
    end
  end
end
