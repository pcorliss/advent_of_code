require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Towers
    attr_accessor :debug
    attr_reader :towers, :descendants, :parent

    TOWER_REGEX = /^(\w+) \((\d+)\)/
    def initialize(input)
      @debug = false
      @towers = {}
      @descendants = {}
      @parent = {}
      @tower_weight = {}
      input.each_line do |line|
        line.chomp!
        if line =~ /^(\w+) \((\d+)\)/
          name = $1
          weight = $2.to_i
          @towers[name] = weight
          _, descendants = line.split('-> ')
          if descendants
            @descendants[name] = descendants.split(', ')
            @descendants[name].each do |desc|
              @parent[desc] = name
            end
          else
            @descendants[name] = []
          end
        end
      end
    end

    def debug!
      @debug = true
    end

    def bottom
      @towers.each do |node, weight|
        return node unless @parent.has_key?(node)
      end
      nil
    end

    def tower_weight(tower)
      @tower_weight[tower] ||= @towers[tower] + @descendants[tower].sum {|t| tower_weight(t)}
    end

    def find_odd_idx(weights)
      weight_count = {}
      weights.each_with_index do |w, idx|
        weight_count[w] ||= 0
        weight_count[w] += 1
      end
      odd_weight = weight_count.find {|w, c| c == 1}.first
      weights.index(odd_weight)
    end

    def reweight
      node = bottom

      weights = []
      odd_idx = -1

      i = 0
      loop do
        new_weights = @descendants[node].map { |desc| tower_weight(desc) }
        puts "Testing: #{node} #{new_weights}" if @debug
        if new_weights.uniq.count == 1
          puts "Found balanced set, previous node #{node} is the bad one" if @debug
          puts "Node: #{node} #{weights}" if @debug
          break
        end

        weights = new_weights
        odd_idx = find_odd_idx(weights)
        node = @descendants[node][odd_idx]
        i += 1
        raise "Too many iterations!!!" if i > 100
      end

      current_weight = weights[odd_idx]
      correct_weight = weights[(odd_idx + 1) % weights.length]
      delta_weight = correct_weight - current_weight
      corrected_tower_weight = @towers[node] + delta_weight

      puts "Weights: #{weights} #{odd_idx}"
      puts "Node: #{node} - Current: #{@towers[node]}" if @debug
      puts "Current: #{current_weight} - Correct: #{correct_weight}" if @debug

      [node, corrected_tower_weight]
    end
  end
end
