require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Slabs
    attr_accessor :debug
    attr_reader :bricks

    Point = Struct.new(:x, :y, :z) do
      def to_a
        [x,y,z]
      end
    end

    def initialize(input)
      @debug = false
      @bricks = input.each_line.map do |line|
        line.split("~").map do |brick|
          Point.new(*brick.split(",").map(&:to_i))
        end
      end
      @bricks_under = {}
      @bricks_above = {}
    end

    # File activesupport/lib/active_support/core_ext/range/overlaps.rb, line 7
    def overlaps?(a, b)
      a.cover?(b.first) || b.cover?(a.first)
    end

    def xy_overlap?(a, b)
      a1, a2 = a
      b1, b2 = b

      overlaps?(a1.x..a2.x, b1.x..b2.x) &&
      overlaps?(a1.y..a2.y, b1.y..b2.y)
    end

    def z_overlap?(a, b)
      a1, a2 = a
      b1, b2 = b

      overlaps?(a1.z..a2.z, b1.z..b2.z)
    end

    def brick_intersects?(a, b)
      xy_overlap?(a, b) && z_overlap?(a, b)
    end

    def drop_bricks!
      @bricks.sort_by! { |brick| brick.map(&:z).min }
      new_bricks = []
      @bricks.each_with_index do |(a1, a2), idx|
        b1, b2 = new_brick = [a1.dup, a2.dup]

        xy_bricks = new_bricks.select { |c| xy_overlap?(c, new_brick) }
        max_z = xy_bricks.map { |c| c.map(&:z).max }.max || 0

        puts "Checking #{new_brick.map(&:to_a)}" if @debug

        raise "b1.z, #{b1.z} is higher than b2.z, #{b2.z}" if b1.z > b2.z

        diff = b1.z - max_z
        b1.z -= diff
        b2.z -= diff

        intersecting_bricks = xy_bricks.select { |c| z_overlap?(c, new_brick) }

        if !intersecting_bricks.empty? || [b1.z,b2.z].min < 1
          b1.z += 1
          b2.z += 1

          @bricks_under[new_brick] = intersecting_bricks
          intersecting_bricks.each do |ibrick|
            @bricks_above[ibrick] ||= []
            @bricks_above[ibrick] << new_brick
          end
          new_bricks << new_brick
          puts "Adding #{new_brick.map(&:to_a)}" if @debug
        end
      end

      new_bricks.sort_by! { |brick| brick.map(&:z).min }
      @bricks = new_bricks
    end

    def disintegratable_bricks
      @bricks.select do |brick|

        bricks_i_support = @bricks_above[brick] || []

        no_bricks_that_depend_on_me = bricks_i_support.empty?
        
        sole_supporter = bricks_i_support.any? do |supporting_brick|
          @bricks_under[supporting_brick].count == 1
        end

        r = no_bricks_that_depend_on_me || !sole_supporter
        puts "Brick #{brick.map(&:to_a).inspect} #{r ? "is" : "not"} disintegratable" if @debug
        r
      end
    end

    def debug!
      @debug = true
    end
  end
end
