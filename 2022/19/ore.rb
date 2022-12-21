require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'deep_clone'
require 'fc'

module Advent

  class Ore
    attr_accessor :debug
    attr_reader :blueprints, :minutes

    MINUTES_PART_1 = 24

    def initialize(input, minutes = MINUTES_PART_1)
      @debug = false
      @minutes = minutes
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

    TYPES = [
      :ore,
      :clay,
      :obsidian,
      :geode,
    ]

    def blueprint_options(blueprint, bounds = {})
      options = []

      goods = []
      blueprint[:robots].each { |type, quant| goods << type if quant > 0 }

      remaining = @minutes - blueprint[:minute]

      TYPES.each do |type|
        cost = blueprint[type]

        next if goods & cost.keys != cost.keys
        next if bounds[type] && bounds[type] <= blueprint[:robots][type]
        
        # figure out minute when we can build
        min_to_build = 1
        cost.each do |cost_type, cost_quant|
          inventory = blueprint[:inventory][cost_type]
          if inventory < cost_quant
            robots = blueprint[:robots][cost_type]
            deficit = cost_quant - inventory
            min = deficit / robots
            min += 1 if deficit % robots > 0
            min_to_build = min + 1 if min + 1 > min_to_build
          end
        end

        # binding.pry if @debug
        # check that it's <= MINUTES
        next if min_to_build + blueprint[:minute] >= @minutes

        # increment to that minute
        build_opt = DeepClone.clone(blueprint)
        build_opt[:minute] += min_to_build
        build_opt[:robots].each do |type, quant|
          build_opt[:inventory][type] += quant * (min_to_build)
        end 

        # subtract costs and add robot
        cost.each do |cost_type, cost_quant|
          build_opt[:inventory][cost_type] -= cost_quant
        end

        # Add the robot
        build_opt[:robots][type] += 1

        # add to options
        options << build_opt

        options
      end

      bp = DeepClone.clone(blueprint)
      bp[:robots].each do |type, quant|
        bp[:inventory][type] += quant * remaining
      end
      bp[:minute] += remaining
      options << bp

      options
    end

    def priority_score(blueprint)
      minutes_remaing = @minutes - blueprint[:minute]

      sum = 0
      # {
      #   :ore => 1,
      #   :clay => 2,
      #   :obsidian => 10,
      #   :geode => 1000,
      # }.each do |type, mult|
      {
        :ore => 0,
        :clay => 1,
        :obsidian => 1,
        :geode => 1000,
      }.each do |type, mult|
        sum += blueprint[:inventory][type] * mult * 2
        sum += blueprint[:robots][type] * mult * minutes_remaing
      end

      sum
    end

    def upper_bound(blueprint)
      max = {geode: 1000}
      TYPES.each do |type|
        blueprint[type].each do |t, c|
          next if t == type
          max[t] ||= 0
          max[t] = c if max[t] < c
        end
      end
      max
    end

    BREAKPOINTS = [
      # {minute: 5, robots: {ore: 2, clay: 0, obsidian: 0, geode: 0}},
      # {minute: 7, robots: {ore: 2, clay: 1, obsidian: 0, geode: 0}},
      # {minute: 8, robots: {ore: 2, clay: 2, obsidian: 0, geode: 0}},
      # {minute: 9, robots: {ore: 2, clay: 3, obsidian: 0, geode: 0}},
      # {minute: 10, robots: {ore: 2, clay: 4, obsidian: 0, geode: 0}},
      # {minute: 11, robots: {ore: 2, clay: 5, obsidian: 0, geode: 0}},
      # {minute: 12, robots: {ore: 2, clay: 6, obsidian: 0, geode: 0}},
      # {minute: 13, robots: {ore: 2, clay: 7, obsidian: 0, geode: 0}},
      # {minute: 14, robots: {ore: 2, clay: 7, obsidian: 1, geode: 0}},
      # {minute: 16, robots: {ore: 2, clay: 7, obsidian: 2, geode: 0}},
      # {minute: 17, robots: {ore: 2, clay: 7, obsidian: 3, geode: 0}},
      # {minute: 19, robots: {ore: 2, clay: 7, obsidian: 4, geode: 0}},
      # {minute: 20, robots: {ore: 2, clay: 7, obsidian: 4, geode: 1}},
      # {minute: 21, robots: {ore: 2, clay: 7, obsidian: 5, geode: 1}},
      # {minute: 22, robots: {ore: 2, clay: 7, obsidian: 5, geode: 2}},
      # {minute: 23, robots: {ore: 2, clay: 7, obsidian: 5, geode: 3}}, #
      # {minute: 24, robots: {ore: 2, clay: 7, obsidian: 5, geode: 4}},
      # {minute: 26, robots: {ore: 2, clay: 7, obsidian: 5, geode: 5}}, #
      # {minute: 27, robots: {ore: 2, clay: 7, obsidian: 5, geode: 6}},
      # {minute: 29, robots: {ore: 2, clay: 7, obsidian: 5, geode: 7}},
      # {minute: 30, robots: {ore: 2, clay: 7, obsidian: 5, geode: 8}},
      # {minute: 31, robots: {ore: 2, clay: 7, obsidian: 5, geode: 9}},
    ]
    

    # This might be easier if we just determined the scarce resources
    def optimize_blueprint(blueprint)
      bounds = upper_bound(blueprint)
      candidates = FastContainers::PriorityQueue.new(:max)
      candidates.push(blueprint, priority_score(blueprint))
  
      best = blueprint
      best_scores = [priority_score(blueprint)]

      i = 0
      until candidates.empty? do
        score = candidates.top_key
        candidate = candidates.pop

        if candidate[:minute] >= @minutes
          if candidate[:inventory][:geode] > best[:inventory][:geode]
            best = candidate
          end
          next
        end

        # Add Prune here based on scores at various minute levels
        # if best_scores[candidate[:minute]].nil? || score > best_scores[candidate[:minute]]
        #   best_scores[candidate[:minute]] = score
        # end
        # if score <= best_scores[candidate[:minute]] * 0.5
        #   next
        # end

        # Assume we can build a geode roboto every turn until the end
        # How many geodes would we have?
        # If less than best, prune
        # Triangle Number n + (n-1) + (n-2) .... 1
        n = @minutes - candidate[:minute]
        utopia_geodes = candidate[:inventory][:geode] + candidate[:robots][:geode]*n + (n**2 + n) / 2
        next if utopia_geodes < best[:inventory][:geode]

        blueprint_options(candidate, bounds).each do |opt|
          # binding.pry if @debug && opt[:robots][:ore] == 1 && opt[:robots][:clay] == 3 && opt[:minute] == 7
          # binding.pry if @debug && opt[:robots][:ore] == 1 && opt[:robots][:clay] == 3 && opt[:robots][:obsidian] == 1 && opt[:minute] == 11 
          # binding.pry if @debug && opt[:robots][:ore] == 1 && opt[:robots][:clay] == 3 && opt[:robots][:obsidian] == 1 && opt[:minute] == 11 
          # binding.pry if @debug && opt[:robots][:geode] == 1
          # binding.pry if @debug && opt[:inventory][:geode] == 12

          # binding.pry if @debug && opt[:robots] == {ore: 1, clay: 4, obsidian: 2, geode: 0} && opt[:minute] == 15
          # binding.pry if @debug && opt[:robots] == {ore: 1, clay: 4, obsidian: 2, geode: 1} && opt[:minute] == 18
          # binding.pry if @debug && opt[:robots] == {ore: 1, clay: 4, obsidian: 2, geode: 2} && opt[:minute] == 21

          # if @debug && BREAKPOINTS.include?(opt.slice(:minute, :robots))
          #   binding.pry
          # end

          candidates.push(opt, priority_score(opt))
        end

        i += 1
        if @debug && i % 10_000 == 0
          puts "Candidates: #{candidates.count}"
          puts "\tCandidate: M:#{candidate[:minute]             } I:#{candidate[:inventory]} R:#{candidate[:robots]} S:#{priority_score(candidate)}"
          puts "\tBest: #{candidate[:id] }    M:#{best[:minute] } I:#{best[:inventory]} R:#{best[:robots]} S:#{priority_score(best)}"
        end
        # if i > 100_000_000
        #   break
        # end
        raise "Too many iterations #{i}" if i > 10_000_000
        # if i > 1_000_000
        #   puts "Too many iterations #{i}. Exiting prematurely"
        #   break
        # end
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

    def first_three_blueprints_long
      best = @blueprints.first(3).map do |bp|
        puts "Starting BP: #{bp}" if @debug
        optimize_blueprint(bp)
      end

      mult = best.inject(1) do |acc, b|
        acc *= b[:inventory][:geode]
      end
      puts "Mult: #{mult}"
    end
  end
end
