require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'fc'

module Advent

  class Valveflow
    attr_accessor :debug
    attr_reader :valves, :tunnels, :travel

    MINUTES = 30
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

      @travel = {}
      precompute_travel
    end

    def precompute_travel
      @tunnels.each do |start, dests|
        dests.each do |dest|
          @travel[start] ||= {}
          @travel[start][dest] = 1
        end
      end

      locations = @travel.keys
      # Wildly inefficient loops to build full travel graph
      3.times do
        locations.each do |a|
          locations.each do |b|
            next if a == b
            locations.each do |c|
              next if a == c || b == c
              # find an intermediary
              # @travel[:AA][:DD] = 1
              # @travel[:DD][:EE] = 1
              # @travel[:AA][:EE] = 2

              if @travel[a][b] && @travel[b][c]
                # puts "#{a} #{b} #{c}"
                @travel[a][c] ||= @travel[a][b] + @travel[b][c]
                @travel[c][a] ||= @travel[a][b] + @travel[b][c]
              end
            end
          end
        end
      end
    end

    def debug!
      @debug = true
    end

    Path = Struct.new(:pos, :valves, :gas, :minutes)

    def most_pressure
      candidates = FastContainers::PriorityQueue.new(:max)
      # candidates = [Path.new(:AA, Set.new, 0, 0)]
      candidates.push(Path.new(:AA, Set.new, 0, 0), 0)
      best = Path.new(:AA, Set.new, 0, MINUTES)

      best_counter = 0

      until candidates.empty? do
        # Currently depth first search
        c = candidates.pop

        # There's a pathological case here that we might be ignoring
        # An early result could prune a good branch
        # Or maybe not since best minutes is also a good measure
        if c.gas < best.gas && c.minutes >= best.minutes
          next
        end

        if c.minutes >= MINUTES || c.valves.count >= @valves.count
          if c.gas > best.gas
            best = c
            best_counter = 0
          end
          next
        end


        if !c.valves.include?(c.pos) && @valves.has_key?(c.pos)
          new_gas = c.gas + @valves[c.pos] * (MINUTES - c.minutes - 1)
          candidates.push(
            Path.new(
              c.pos,
              c.valves.clone.add(c.pos),
              new_gas,
              c.minutes + 1
            ),
            new_gas / (c.minutes + 1)
          )
        end
        # @travel[c.pos].each do |new_pos, distance|
        # We should change this to instead only go to remaining
        # valves and then just include the cost
        # Would save lots and lots of branches
        @tunnels[c.pos].each do |new_pos|
          candidates.push(
            Path.new(
              new_pos,
              c.valves.clone,
              c.gas,
              c.minutes + 1
            ),
            c.gas / (c.minutes + 1)
          )
        end

        best_counter += 1

        if @debug && best_counter % 100_000 == 0
          puts "Candidates Length: #{candidates.count}"
          puts "Candidate: #{c}"
          puts "Best: #{best}"
        end

        if best_counter > 10_000_000
          return best
        end
        # raise "Too many iterations!!!" if i > 100_000_000
      end

      best
    end
  end
end
