require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'deep_clone'

module Advent

  class Gridcomp
    attr_accessor :debug
    attr_reader :nodes

    FS_REGEX = /^\/dev\/grid\/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)%$/

    def initialize(input)
      @debug = false
      @nodes = []
      input.each_line do |line|
        line.chomp!
        if line =~ FS_REGEX
          @nodes << [[$1.to_i, $2.to_i], $3.to_i, $4.to_i]
        end
      end
      @adjacent = {}
    end

    def debug!
      @debug = true
    end

    POS = 0
    SIZE = 1
    USED = 2

    def viable_pair?(a, b)
      return false if a[USED] == 0
      return false if a[POS] == b[POS]
      return false if a[USED] > (b[SIZE] - b[USED])
      true
    end

    def count_viable_pairs
      count = 0
      @nodes.combination(2).each do |combo|
        count += 1 if viable_pair?(*combo)
        count += 1 if viable_pair?(*combo.reverse)
      end
      count
    end

    def adjacent?(a, b)
      # return @adjacent[[a, b]] if @adjacent.has_key?([a, b])
      xa, ya = a[POS]
      xb, yb = b[POS]

      x_delta = (xa - xb).abs
      y_delta = (ya - yb).abs

      #@adjacent[[a,b]] = x_delta + y_delta == 1
      x_delta + y_delta == 1
    end

    # This won't complete with our larger input as there are a few things at play here
    # 1. A search space that is far too large
    # 2. In reality the notes that can be moved all revolve around:
    #  a. getting the empty space next to the goal
    #  b. Going around the wall
    #  c. Shuffling the goal towards the destination
    def fewest_steps
      read_point = [0,0]
      max_x = @nodes.map(&:first).map(&:first).max
      data_pos = [max_x, 0]

      steps = 1
      paths = [[DeepClone.clone(@nodes), DeepClone.clone(data_pos)]]

      node_lookup = {}
      @nodes.each_with_index do |n, idx|
        node_lookup[n[POS]] = idx
      end

      adjacent_list = Set.new
      nodes.combination(2).each do |combo|
        a, b = combo
        if adjacent?(*combo)
          adjacent_list.add([a[POS],b[POS]])
          adjacent_list.add([b[POS],a[POS]])
        end
      end

      loop do
        new_paths = []
        puts "#{steps}: #{paths.count} #{paths.map(&:last).uniq}" if @debug
        paths.each do |path|
          nodes, path_data_pos = path
          moves = []
          adjacent_list.each do |a, b|
            combo = [nodes[node_lookup[a]], nodes[node_lookup[b]]]
            moves << combo if viable_pair?(*combo)
          end

          puts "\t #{steps} Working on: #{moves.count} moves" if @debug && false
          moves.each do |move|
            a, b = move
            next if b[POS] == path_data_pos
            # puts "Moving: #{a} #{b}" if @debug && a[POS] != path_data_pos
            # puts "Moving: #{a} #{b} -- G" if @debug && a[POS] == path_data_pos
            new_nodes = DeepClone.clone(nodes)
            a = new_nodes[node_lookup[a[POS]]]
            b = new_nodes[node_lookup[b[POS]]]
            new_data_pos = path_data_pos
            new_data_pos = b[POS] if a[POS] == path_data_pos

            b[USED] += a[USED]
            a[USED] = 0
            if @debug && false
              if a[POS] == path_data_pos
                print "\tG\t"
              else
                print "\t\t"
              end
              print "#{steps}: #{a} => #{b}\n"
            end
            # puts "g: #{a} => #{b}" if @debug
            return steps if new_data_pos == read_point
            new_paths << [new_nodes, new_data_pos]
          end
        end

        paths = new_paths
        raise "Unable to find path #{steps}" if paths.empty?
        raise "Too many iterations!!! #{steps}"  if steps >= 100
        steps += 1
      end
    end

    def render
      grid.render
    end

    def grid
      return @g if @g
      @g = Grid.new
      max_x = @nodes.map(&:first).map(&:first).max
      @nodes.each do |node|
        char = '.'
        char = '#' if node[SIZE] > 400
        char = '_' if node[USED] == 0
        char = 'X' if node[POS] == [0,0]
        char = 'G' if node[POS] == [max_x, 0]
        @g[node[POS]] = char
      end
      @g
    end

    def distance_to_target
      g = grid
      goal_x, goal_y = g.cells.find { |cell, val| val == 'G' }.first
      target_x, target_y = g.cells.find { |cell, val| val == 'X' }.first
      (goal_x - target_x).abs + (goal_y - target_y).abs
    end

    def distance_to_goal
      g = grid
      empty_pos = g.cells.find { |cell, val| val == '_' }.first

      paths = [[empty_pos]]
      visited = Set.new(empty_pos)
      steps = 0
      loop do
        steps += 1
        new_paths = []
        #puts "#{steps} - Paths: #{paths.count} -- Sameple: #{paths.first}" if @debug
        paths.each do |path|
          current = path.last
          g.neighbors(current).each do |neighbor, val|
            if val == 'G' && current[1] == 0 && neighbor[1] == 0
              path.each do |n|
                g[n] = 'S'
              end
              puts g.render if @debug
              return steps + 1
            end
            next unless val == '.'
            next if visited.include? neighbor

            visited.add neighbor
            new_paths << path + [neighbor]
          end
        end
        paths = new_paths
        raise "Too many iterations" if steps > 70
      end
    end
  end
end
