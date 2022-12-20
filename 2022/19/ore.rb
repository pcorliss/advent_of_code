require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'deep_clone'
require 'fc'

module Advent

  class Ore
    attr_accessor :debug
    attr_reader :blueprints

    MINUTES = 24

    def initialize(input)
      @debug = false
      @blueprints = []
      input.each_line do |line|
        line.chomp!
        blueprint, instructions = line.split(': ')
        x, id = blueprint.split(' ')
        @blueprints << {
          id: id.to_i,
          robots: {ore: 1, clay: 0, obsidian: 0, geode: 0},
          inventory: {ore: 0, clay: 0, obsidian: 0, geode: 0},
          minute: 0,
        }
        instructions.split('.').each do |inst|
          if inst =~ /Each (\w+) robot costs (.*)/
            robot_type = $1
            costs = $2.split(' and ')
            costs.each do |cost|
              quant, type = cost.split(' ')
              @blueprints.last[robot_type.to_sym] ||= {}
              @blueprints.last[robot_type.to_sym].merge!({type.to_sym => quant.to_i})
            end
          end
        end
      end
    end

    def debug!
      @debug = true
    end

    def blueprint_options(blueprint)
      # Spend to build - use `blueprint` instead of clone
      # Figure out what we can afford
      afford = [:ore, :clay, :obsidian, :geode].select do |type|
        cost = blueprint[type]
        cost.all? do |cost_type, quant|
          blueprint[:inventory][cost_type] >= quant
        end
      end

      # Collect - doesn't add until end
      bp = DeepClone.clone(blueprint)
      bp[:robots].each do |type, quant|
        bp[:inventory][type] += quant
      end

      bp[:minute] += 1

      options = [bp]
      # Build Robot
      afford.each do |type|
        new_opt = DeepClone.clone(bp)
        bp[type].each do |cost_type, cost|
          new_opt[:inventory][cost_type] -= cost
        end
        new_opt[:robots][type] += 1
        options << new_opt
      end

      options
    end

    def priority_score(blueprint)
      minutes_remaing = MINUTES - blueprint[:minute]

      sum = 0
      {
        :ore => 1,
        :clay => 2,
        :obsidian => 10,
        :geode => 1000,
      }.each do |type, mult|
        sum += blueprint[:inventory][type] * mult
        sum += blueprint[:robots][type] * mult * minutes_remaing
      end

      sum
    end

    def optimize_blueprint(blueprint)
      candidates = FastContainers::PriorityQueue.new(:max)
      candidates.push(blueprint, priority_score(blueprint))
  
      best = blueprint
      best_scores = [priority_score(blueprint)]

      i = 0
      until candidates.empty? do
        score = candidates.top_key
        candidate = candidates.pop

        if candidate[:minute] >= MINUTES
          if candidate[:inventory][:geode] > best[:inventory][:geode]
            best = candidate
          end
          next
        end

        # Add Prune here based on scores at various minute levels
        if best_scores[candidate[:minute]].nil? || score > best_scores[candidate[:minute]]
          best_scores[candidate[:minute]] = score
        end

        if score <= best_scores[candidate[:minute]] * 0.75
          next
        end
        

        blueprint_options(candidate).each do |opt|
          candidates.push(opt, priority_score(opt))
        end

        i += 1
        if @debug && i % 10_000 == 0
          puts "Candidates: #{candidates.count}"
          puts "\tCandidate: #{candidate[:inventory]} #{candidate[:robots]} #{priority_score(candidate)}"
          puts "\tBest: #{candidate[:id]}   #{best[:inventory]} #{best[:robots]} #{priority_score(best)}"
        end
        if i > 1_000_000
          break
        end
        # raise "Too many iterations #{i}" if i > 1_000_000
      end

      best
    end

    def quality_levels
      optimized = @blueprints.map do |bp|
        optimize_blueprint(bp)
      end
      puts "Optimized: " if @debug
      pp optimized if @debug
      optimized.sum do |opt|
        opt[:inventory][:geode] * opt[:id]
      end
    end
  end
end
