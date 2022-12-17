require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'fc'
require 'deep_clone'

module Advent

  class Valveflow
    attr_accessor :debug, :minutes
    attr_reader :valves, :tunnels, :travel

    START = :AA

    def initialize(input)
      @debug = false
      @valves = {}
      @tunnels = {}
      input.each_line do |line|
        if line =~ /Valve ([A-Z]+) has flow rate=(\d+); tunnel[s]* lead[s]* to valve[s]* (.*)$/
          valve, flow, leads = $1, $2, $3
          @valves[valve.to_sym] = flow.to_i unless flow.to_i.zero?
          tunnels = leads.split(', ').map(&:to_sym)
          @tunnels[valve.to_sym] = tunnels
        end
      end

      @minutes = 30

      @travel = {}
      precompute_travel
    end

    def precompute_travel
      locations = @tunnels.keys

      require 'timeout'
      Timeout::timeout(5) do
        locations.each do |a|
          destinations = @tunnels[a].map {|d| [a, d]}
          until destinations.empty? do
            dest = destinations.shift
            @travel[a] ||= {}
            next if dest.last == a
            next if @travel[a][dest.last]
            @travel[a][dest.last] = dest.count - 1
            destinations.concat @tunnels[dest.last].map {|d| dest.clone << d}
          end
        end
      end

      ignore = @travel.keys - @valves.keys
      locations.each do |l|
        ignore.each do |i|
          @travel[l].delete(i)
        end
      end
    end

    def debug!
      @debug = true
    end

    Path = Struct.new(:pos, :valves, :gas, :minutes)

    def most_pressure
      candidates = FastContainers::PriorityQueue.new(:max)
      candidates.push(Path.new(:AA, Set.new, 0, 0), 0)
      best = Path.new(:AA, Set.new, 0, @minutes)

      i = 0
      best_counter = 0

      # follow_path = [:DD, :BB, :JJ, :HH, :EE, :CC]

      until candidates.empty? do
        c = candidates.pop

        if c.gas > best.gas
            best = c
            best_counter = 0
        end

        @travel[c.pos].each do |new_pos, distance|
          next if c.valves.include? new_pos
          new_minutes = c.minutes + distance + 1
          next if new_minutes > @minutes
          new_gas = c.gas + @valves[new_pos] * (@minutes- new_minutes)

          candidates.push(
            Path.new(
              new_pos,
              c.valves.clone.add(new_pos),
              new_gas,
              new_minutes,
            ),
            new_gas
          )
        end

        best_counter += 1
        i += 1

        if @debug && i % 100_000 == 0
          puts "Candidates Length: #{candidates.count}"
          puts "Candidate: #{c}"
          puts "Best: #{best}"
        end

        # if best_counter > 10_000_000
        #   return best
        # end
        # raise "Too many iterations!!!" if i > 100_000_000
      end

      puts "I: #{i}" if @debug
      best
    end

    EPath = Struct.new(:poss, :valves, :gas, :minutes, :paths)

    def elephant_assisstance
      @minutes = 26
      candidates = FastContainers::PriorityQueue.new(:max)
      candidates.push(EPath.new([:AA, :AA], Set.new, 0, [0,0], [[:AA],[:AA]]), 0)
      best = EPath.new([:AA, :AA], Set.new, 0, [@minutes, @minues], [])

      i = 0
      best_counter = 0

      max_gas_rate = @valves.values.sum
      possible_valves = Set.new @valves.keys

      # follow_path = [:DD, :BB, :JJ, :HH, :EE, :CC]

      until candidates.empty? do
        c = candidates.pop

        if c.gas > best.gas
          best = c
          best_counter = 0
        end

        next if c.valves.count >= possible_valves.count

        c.poss.each_with_index do |pos, idx|
          @travel[pos].each do |new_pos, distance|
            next if c.valves.include? new_pos
            new_minutes = c.minutes[idx] + distance + 1
            next if (new_minutes + 1) > @minutes
            new_gas = c.gas + @valves[new_pos] * (@minutes - new_minutes)
          
            new_poss = c.poss.clone
            new_poss[idx] = new_pos
            new_minutes_arr = c.minutes.clone
            new_minutes_arr[idx] = new_minutes

            # possible_rate = @valves.values_at(*(possible_valves - c.valves)).sum

            # Prune if can't possibly improve situation
            # This eliminates the optimal path.. But Why?
            remaining = (@minutes*2) - new_minutes_arr.sum
            # next if ((possible_rate * remaining) + new_gas) < best.gas
            next if ((max_gas_rate * remaining) + new_gas) < best.gas

            new_paths = DeepClone.clone(c.paths)
            new_paths[idx].push new_pos

            candidates.push(
              EPath.new(
                new_poss,
                c.valves.clone.add(new_pos),
                new_gas,
                new_minutes_arr,
                new_paths,
              ),
              new_gas / new_minutes_arr.sum
            )
          end
        end

        best_counter += 1
        i += 1

        if @debug && i % 100_000 == 0
          puts "Candidates Length: #{candidates.count}"
          puts "Candidate: #{c}"
          puts "Best: #{best}"
        end

        # if best_counter > 10_000_000
        #   return best
        # end
        # raise "Too many iterations!!!" if i > 100_000_000
      end

      puts "I: #{i}" if @debug
      puts "Best: #{best}" if @debug
      best
    end
  end
end
