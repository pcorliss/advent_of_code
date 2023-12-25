require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Snowverload
    attr_accessor :debug
    attr_reader :components, :conns, :nodes

    def initialize(input)
      @debug = false
      @components = {}
      input.each_line do |line|
        key, value = line.chomp.split(': ')
        @components[key] = value.split
      end

      @conns = {}
      @nodes = Set.new
      @components.each do |key, value|
        @nodes << key
        @conns[key] ||= Set.new
        value.each do |v|
          @conns[key] << v
          @conns[v] ||= Set.new
          @conns[v] << key
          @nodes << v
        end
      end
    end

    def debug!
      @debug = true
    end

    def state_diagram
      sd = "flowchart TD\n"
      @components.each do |key, connections|
        connections.each do |c|
          sd << "#{key} --- #{c}\n"
        end
      end
      sd
    end

    def group_count(cuts)
      group = Set.new([nodes.first])
      nodes_to_walk = [nodes.first]
      cut_set = cuts.to_set
      cuts.each do |cut|
        cut_set << cut.reverse
      end

      until nodes_to_walk.empty?
        n = nodes_to_walk.pop
        @conns[n].each do |conn|
          next if group.include?(conn)
          next if cut_set.include?([n, conn])
          group << conn
          nodes_to_walk << conn
        end
      end

      [group.count, nodes.count - group.count]
    end

    def maximize_groups_slow(cuts: 3)
      conn_list = []

      @components.each do |key, value|
        value.each do |v|
          conn_list << [key, v]
        end
      end

      best_count = nodes.count
      best = [0,0]
      conn_list.combination(cuts).each do |combo|
        c = group_count(combo)
        if c.max - c.min < best_count
          best_count = c.max - c.min
          best = c
          puts "New Best: #{best_count} #{best}" if @debug
        end
      end

      best
    end

    def maximize_groups(cuts: 3)
      best_count = nodes.count
      best = [0,0]
      common = find_common_paths(top: cuts)
      group_count(common)
    end

    def bfs(start, goal)
      queue = [[start]]
      visited = Set.new

      until queue.empty?
        path = queue.shift
        node = path.last
        next if visited.include?(node)
        visited << node
        return path if node == goal
        @conns[node].each do |conn|
          queue << path + [conn]
        end
      end

      raise "Unable to find path"
    end

    def find_common_paths(top: 3, iterations: 10000)
      paths = {}

      node_list = @nodes.to_a
      iterations.times do |j|
        s = node_list[rand(node_list.count)]
        e = node_list[rand(node_list.count)]
        bfs(s, e).each_cons(2) do |a, b|
          p = [a,b].sort
          paths[p] ||= 0
          paths[p] += 1
        end
        # Short circuits early if we discovered cuts that work
        if j % 100 == 0
          best_paths = paths.sort_by {|k,v| v }.reverse.first(top).map(&:first)
          a, b = group_count(best_paths)
          return best_paths if a != nodes.count
        end
      end

      best_paths = paths.sort_by {|k,v| v }.reverse.first(top)
      puts "Best Paths: #{best_paths}" if @debug
      best_paths.map(&:first)
    end
  end
end
