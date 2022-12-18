require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Lava
    attr_accessor :debug
    attr_reader :cubes

    def initialize(input)
      @debug = false
      @cubes = Set.new input.each_line.map do |line|
        line.chomp!
        line.split(',').map(&:to_i)
      end
    end

    def debug!
      @debug = true
    end

    def exposed_sides(cubes = @cubes)
      matched_sides = 0
      cubes.to_a.combination(2) do |a, b|
        a_x, a_y, a_z = a
        b_x, b_y, b_z = b

        if (a_x - b_x).abs + (a_y - b_y).abs + (a_z - b_z).abs == 1
          matched_sides += 1
          puts "Adjacent: #{a}, #{b}" if @debug
        end
      end

      (cubes.count * 6) - matched_sides * 2
    end

    X = 0
    Y = 1
    Z = 2

    def bounding_box(cubes)
      min, max = [], []
      @cubes.each do |cube|
        x, y, z = cube
        min[X] = x if min[X].nil? || x < min[X]
        min[Y] = y if min[Y].nil? || y < min[Y]
        min[Z] = z if min[Z].nil? || z < min[Z]
        max[X] = x if max[X].nil? || x > max[X]
        max[Y] = y if max[Y].nil? || y > max[Y]
        max[Z] = z if max[Z].nil? || z > max[Z]
      end
      puts "Bounding Box Min: #{min} Max: #{max}" if @debug
      [min, max]
    end

    def center_point(min, max)
      center = [
        (max[X] - min[X]) / 2 + min[X],
        (max[Y] - min[Y]) / 2 + min[Y],
        (max[Z] - min[Z]) / 2 + min[Y],
      ]
      puts "Center Point: #{center} #{@cubes.include? center}" if @debug
      center
    end

    NEIGHBORS = [[-1,0,0],[1,0,0],[0,-1,0],[0,1,0],[0,0,-1],[0,0,1]]

    def inside_cube?(cube, min, max)
      x, y, z = cube
      NEIGHBORS.all? do |d_x, d_y, d_z|
        edge = false
        collision = false
        amp = 0
        until edge || collision do
          coord = [x + d_x*amp, y + d_y*amp, z + d_z*amp]
          # Just in case there's some off by one we add 2 to the edges
          edge ||= coord[X] > (max[X]+2) || coord[X] < (min[X]-2)
          edge ||= coord[Y] > (max[Y]+2) || coord[Y] < (min[Y]-2)
          edge ||= coord[Z] > (max[Z]+2) || coord[Z] < (min[Z]-2)
          break if edge
            
          collision = @cubes.include? coord
          break if collision

          amp += 1
          raise "Too many iterations on inside check!" if amp > 100
        end
        puts "\t#{cube} - #{[d_x,d_y,d_z]} - #{collision} - #{edge}" if @debug && cube == [2,2,5]

        collision
      end
    end

    def find_unoccupied_inside_cube(min, max, center)
      candidates = [center]
      seen = Set.new [center]
      unoccupied_center = nil
      until candidates.empty? do
        c = candidates.shift # BFS

        # Inside?
        x, y, z = c

        if ! @cubes.include? c

          inside = inside_cube?(c, min, max)
          puts "#{c} is inside? #{inside}" if @debug && c == [2,2,5]

          if inside
            unoccupied_center = c
            break
          end
        end

        # Add neighbors
        NEIGHBORS.each do |d_x, d_y, d_z|
          new_candidate = [x + d_x, y + d_y, z + d_z]
          next if seen.include? new_candidate
          seen.add new_candidate
          candidates << new_candidate
        end

        raise "Can't find an unoccupied center" if candidates.length > 1000
      end
      raise "Couldn't find unoccupied center!!!" if unoccupied_center.nil?

      puts "Unoccupied Center #{unoccupied_center}" if @debug
      unoccupied_center
    end

    def fill_center(unoccupied_center)
      center_cubes = Set.new [unoccupied_center]
      candidates = [unoccupied_center]
      i = 0
      until candidates.empty? do
        c = candidates.shift # BFS

        puts "Candidates: #{candidates.count}" if @debug
        puts "Candidate: #{c}" if @debug
        puts "Center Cubes: #{center_cubes.count}" if @debug

        NEIGHBORS.each do |d_x, d_y, d_z|
          x, y, z = c
          new_candidate = [x + d_x, y + d_y, z + d_z]

          next if center_cubes.include? new_candidate
          next if @cubes.include? new_candidate

          puts "\tAdding Neighbor #{new_candidate} candidate" if @debug
          # binding.pry if @debug
          center_cubes.add new_candidate
          candidates << new_candidate
        end

        i += 1
        raise "Too many iterations!!!" if i > 10000
      end
      center_cubes
    end

    def interior_sides
      # Bounding Box
      min, max = bounding_box(@cubes)

      # Center Point of Bounding Box
      center = center_point(min, max)

      # Find unoccupied cube in center
      unoccupied_center = find_unoccupied_inside_cube(min, max, center)

      # Identify neighboring cubes that make up the unoccupied center
      center_cubes = fill_center(unoccupied_center)

      exposed_sides(center_cubes)
    end
  end
end
