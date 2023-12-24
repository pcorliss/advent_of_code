require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Hike
    attr_accessor :debug
    attr_reader :grid, :start, :finish, :graph, :graph_keys

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @start = [1,0]
      @grid.width.times do |x|
        y = @grid.height - 1
        if @grid[x,y] == '.'
          @finish = [x,y]
          break
        end
      end
    end

    def debug!
      @debug = true
    end

    SLOPES = {
      '>' => [1,0],
      '<' => [-1,0],
      '^' => [0,-1],
      'v' => [0,1],
    }

    def longest_hike_slow(ignore_slopes: false)
      # if you step onto a slope tile, your next step must be downhill (in the direction the arrow is pointing)
      # never step onto the same tile twice
      branches = [[@start, Set.new([[@start]])]]
      hikes = []
      i = 0
      until branches.empty? do
        new_branches = []
        puts "#{i}: Branches: #{branches.count}" if @debug
        branches.each do |branch|
          pos, path = branch
          if pos == @finish
            hikes << branch
            next
          end

          x,y = pos
          neighbors = @grid.neighbors(pos).select do |(nx, ny), val|
            next if val == '#'
            next if path.include?([nx, ny])
            next if val.nil?
            if !ignore_slopes && SLOPES.keys.include?(val)
              dx = nx - x
              dy = ny - y
              next unless SLOPES[val] == [dx, dy]
            end
            true
          end

          # We do it this way to avoid expensive duplication of large sets
          neighbors.each_with_index do |((nx, ny), val), idx|
            if idx == neighbors.length - 1
              npath = path << [nx, ny]
            else
              npath = path.dup << [nx, ny]
            end
            new_branches << [[nx, ny], npath]
          end
        end
        branches = new_branches
        i += 1
        raise "Too many iterations #{i}" if i > 10000
      end

      puts "Hikes: #{hikes.count}, #{hikes.map(&:last).map(&:length).sort}" if @debug
      hikes.map(&:last).map(&:length).max - 1
    end

    def new_key
      letters = ('A'..'Z').to_a + ('a'..'z').to_a
      available_letters = (letters - @graph_keys.values).sort
      if available_letters.empty?
        @key_counter ||= 0
        return @key_counter += 1
      end
      available_letters.first
    end

    def distance(a, b)
      apos = @graph_keys.find {|k,v| v == a}.first
      bpos = @graph_keys.find {|k,v| v == b}.first

      raise "Wrong Graph Dist! #{a}, #{b}, #{apos}, #{bpos}" unless @graph[apos][bpos] == @graph[apos][bpos]
      @graph[apos][bpos]
    end

    def build_graph
      @graph = {}
      @graph_keys = {@start => 'S', @finish => 'F'}
     
                  # [ current, previous node ]
      branches = [[@start, @start, [@start]]]
      visited_nodes = Set.new([@start])
      visited_pos = Set.new([@start])

      i = 0
      until branches.empty? do
        new_branches = []
        # puts "#{i}: Branches: #{branches.count}" if @debug
        branches.each do |branch|
          pos, prev_node, path = branch

          x,y = pos
          neighbors = @grid.neighbors(pos).select do |(nx, ny), val|
            next if val == '#'
            next if val.nil?
            # Don't turn around
            next if path[-2] == [nx, ny]
            true
          end

          # We've reached a dead end?
          next if neighbors.empty?

          if neighbors.length > 1
            # We've found a point where we branch off
            @graph[pos] ||= {}
            @graph[prev_node] ||= {}
            @graph[pos][prev_node] = path.length - 1
            @graph[prev_node][pos] = path.length - 1

            # We've already been to this node and branched off
            next if visited_nodes.include?(pos) && pos != @start
            visited_nodes << pos

            @graph_keys[pos] = new_key
            # binding.pry if @debug && @graph_keys[pos] == 'B'

            neighbors.each do |(nx, ny), val|
              visited_pos << [nx, ny]
              new_branches << [[nx, ny], pos, [pos, [nx, ny]]]
            end

            next
          end

          (nx, ny), val = neighbors.first

          # We've reached the finish, mark on the graph
          if [nx, ny] == @finish
            npos = [nx, ny]
            @graph[npos] ||= {}
            @graph[prev_node] ||= {}
            @graph[npos][prev_node] = path.length
            @graph[prev_node][npos] = path.length
            next
          end

          # We're walking down a hallway
          visited_pos << [nx, ny]
          path << [nx, ny]
          new_branches << [[nx, ny], prev_node, path]
        end
        branches = new_branches
        i += 1
        raise "Too many iterations #{i}" if i > 10000
        raise "Too many branches #{branches.count}" if branches.count > 20000
      end

      @graph
    end

    def render_graph_on_grid(highlight: true)
      nodes = @graph.keys.to_set
      nodes.each do |x,y|
        @grid[x,y] = @graph_keys[[x,y]] || '99999'
      end
      highlight ? @grid.highlight : @grid.render
    end

    def longest_hike(ignore_slopes: false)
      return longest_hike_slow unless ignore_slopes

      build_graph

      # pos, steps, visited
      branches = [[@start, 0, Set.new([@start])]]
      hikes = []
      longest_hike_path = []

      i = 0
      until branches.empty? do
        puts "Branches: #{branches.count} Hikes: #{hikes.count} - #{branches.last} #{hikes.max}" if @debug
        pos, steps, visited = branches.pop


        if pos == @finish
          longest_hike_path = visited if hikes.empty? || steps > hikes.max
          hikes << steps
          next
        end

        @graph[pos].each do |npos, dist|
          next if visited.include?(npos)
          branches << [npos, steps + dist, visited + [npos]]
        end

        i += 1
        raise "Too many iterations #{i}" if i > 100000000
      end

      # puts "Hikes: #{hikes.count}, #{hikes.sort}, #{longest_hike_path}" if @debug
      if @debug
        longest_hike_path.each_cons(2) do |a, b|
          aname = @graph_keys[a]
          bname = @graph_keys[b]
          puts "#{aname} -> #{bname} : #{@graph[a][b]}"
        end
      end
      hikes.max
    end

    def state_diagram
      sd = ''
      sd << "flowchart TD" << "\n"
      visited = Set.new
      sd << "S ---|#{distance('S','A')}| A" << "\n"
      visited << [@graph[@start].keys.first, @start]
      visited << [@start, @graph[@start].keys.first]
      @graph.each do |a, neighbors|
        aname = @graph_keys[a]
        neighbors.each do |b, dist|
          next if visited.include?([b,a])
          visited << [a,b]
          bname = @graph_keys[b]
          sd << "#{aname} ---|#{dist}| #{bname}" << "\n"
        end
      end

      # Output is usable with https://mermaid.live/
      # Reveals a diagram where 4 paths with about 12-bits of state
      # Certain bits need to be on in order to send the right pulse to the aggregator
      sd
    end
  end
end
