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
            # puts "Goal Moving: #{a} #{b}" if @debug && a[POS] == path_data_pos
            new_nodes = DeepClone.clone(nodes)
            a = new_nodes.find {|n| n == a}
            b = new_nodes.find {|n| n == b}
            new_data_pos = path_data_pos
          begin
            new_data_pos = b[POS] if a[POS] == path_data_pos
          rescue => e
            binding.pry
            raise e
          end


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
        raise "Too many iterations!!! #{steps}"  if steps >= 10
        steps += 1
      end
    end
  end
end
