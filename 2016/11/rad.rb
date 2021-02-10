require 'set'
require 'deep_clone'
require '../lib/grid.rb'

module Advent

  class Rad
    attr_accessor :debug
    attr_reader :floors, :obj_map

    GEN_REGEX = /a (\w+) generator/
    CHIP_REGEX = /a (\w+)-compatible microchip/

    def initialize(input)
      @debug = false
      @floors = []

      generators = []
      microchips = []

      input.each_line.each do |line|
        generators << line.scan(GEN_REGEX).flatten.map {|gen| gen + "-g"}
        microchips << line.scan(CHIP_REGEX).flatten.map {|mic| mic + "-m"}
      end

      @obj_map = []
      @obj_map.concat generators.flatten.sort
      @obj_map.concat microchips.flatten.sort.reverse

      @floors = []
      (0..3).each do |floor|
        @floors[floor] = Set.new
        if generators[floor]
          generators[floor].each do |gen|
            @floors[floor].add @obj_map.index(gen)
          end
        end
        if microchips[floor]
          microchips[floor].each do |gen|
            @floors[floor].add @obj_map.index(gen)
          end
        end
      end
    end

    def obj_lookup(ids)
      ids.map {|id| @obj_map[id]}
    end

    def id_lookup(objs)
      objs.map {|obj| @obj_map.index(obj)}
    end

    def debug!
      @debug = true
    end

    def failure?(state)
      complement = @obj_map.length - 1
      # chips are at the high end, generators at the low end
      # generator if id <= complement / 2
      (1..4).each do |floor|
        objs = state[floor]
        unmatched_chip = false
        gen = false
        objs.each do |o|
          if o <= complement / 2
            gen = true
          else
            # Checks for matched pairs
            unmatched_chip ||= !objs.include?(complement - o)
            return true if unmatched_chip && gen
          end
        end
      end
      false
    end

    def success?(state)
      return false if state[0] != 4
      s = (1..3).all? do |floor|
        state[floor].empty?
      end
      puts "Success: #{state}" if @debug && s
      s
    end

    def pairing_state(state)
      complement = @obj_map.length - 1
      s = (1..4).map do |floor|
        objs = state[floor]
        unmatched = Set.new
        pairs = 0
        objs.each do |o|
          if objs.include?(complement - o)
            pairs += 1
          else
            unmatched.add o
          end
        end
        [pairs, unmatched]
      end
      s = [state.first] + s
      s << state.last if state.length > 5
      # puts "S: #{s}" if @debug
      s.hash
    end

    def score(state)
      s = (1..4).sum do |floor|
        state[floor].count * floor
      end
      s -= state.last if state.length > 5
      s
    end

    def find_solution_prime
      initial_state = [1] + DeepClone.clone(@floors) + [0]
      pair_states = Set.new()
      pri_queue = {score(initial_state) => [initial_state]}
      i = 0
      loop do
        i += 1
        raise "Too many iterations!!" if i > 100
        top_score = pri_queue.keys.max
        puts "Score: #{top_score} Possibilites: #{pri_queue[top_score].length} - Sample: #{pri_queue[top_score].first}" if @debug
        new_states = []
        pri_queue[top_score].each do |state|
          pos = state[0]
          objs = state[pos]
          combos = objs.map {|o| [o]}.to_a + objs.to_a.combination(2).to_a
          [pos-1,pos+1].each do |new_floor|
            next if new_floor < 1 || new_floor > 4
            step_down = pos - 1 == new_floor
            step_up = !!step_down
            next if pos - 1 == new_floor && (1..new_floor).all? { |f| state[f].empty? } # don't bother stepping down to floors that are empty below us
            combos.reverse! if combos.first.length == 1 && step_up
            combos.each do |combo|
              next if step_down && combo.count == 2 && !new_states.empty? # Don't move two down if you can avoid it
              # next if step_up &&   combo.count == 1 && !new_states.empty? # Don't move just one up if we can
              new_state = DeepClone.clone(state)
              new_state[0] = new_floor
              new_state[5] += 1
              new_state[pos] -= combo
              new_state[new_floor] += combo

              next if failure?(new_state)
              # We could do something a little smarter here where we map the state to a number of steps
              # if the number of steps is less we prune, if not we update
              next if pair_states.include? pairing_state(new_state)
              return new_state[5] if success?(new_state)
              pair_states.add pairing_state(new_state)

              new_states << new_state
            end
          end
        end
        pri_queue.delete(top_score)
        new_states.each do |state|
          s = score(state)
          pri_queue[s] ||= []
          pri_queue[s] << state
        end
      end
    end

    def find_solution
      initial_state = [1] + DeepClone.clone(@floors)
      # previous = Set.new(initial_state)
      pair_states = Set.new()
      queue = [initial_state]

      steps = 0
      while steps < 100 do
        new_queue = []
        puts "Step: #{steps} Possibilites: #{queue.length}" if @debug
        queue.each do |state|
          pos = state[0]
          objs = state[pos]
          combos = objs.map {|o| [o]}.to_a + objs.to_a.combination(2).to_a
          [pos-1,pos+1].each do |new_floor|
            next if new_floor < 1 || new_floor > 4
            step_down = pos - 1 == new_floor
            step_up = !!step_down
            next if pos - 1 == new_floor && (1..new_floor).all? { |f| state[f].empty? }
            new_states = []
            combos.reverse! if combos.first.length == 1 && step_up
            combos.each do |combo|
              next if step_down && combo.count == 2 && !new_states.empty? # Don't move two down if you can avoid it
              # next if step_up &&   combo.count == 1 && !new_states.empty? # Don't move just one up if we can
              new_state = DeepClone.clone(state)
              new_state[0] = new_floor
              new_state[pos] -= combo
              new_state[new_floor] += combo

              next if failure?(new_state)
              # next if previous.include? new_state
              next if pair_states.include? pairing_state(new_state)
              return steps + 1 if success?(new_state)
              # previous.add state
              pair_states.add pairing_state(new_state)

              new_states << new_state
            end
            new_queue.concat new_states
          end
        end
        queue = new_queue
        steps += 1
      end

      raise "Fail!"
    end
  end
end
