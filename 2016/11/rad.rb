require 'set'
require 'deep_clone'
require '../lib/grid.rb'

module Advent

  class Rad
    attr_accessor :debug
    attr_reader :floors

    GEN_REGEX = /a (\w+) generator/
    CHIP_REGEX = /a (\w+)-compatible microchip/

    def initialize(input)
      @debug = false
      @floors = []
      input.each_line.each do |line|
        floor = line.scan(GEN_REGEX).flatten.map {|gen| gen + "-g"} +
          line.scan(CHIP_REGEX).flatten.map {|mic| mic + "-m"}

        @floors << Set.new(floor)
      end
    end

    def debug!
      @debug = true
    end

    def failure?(state)
      (1..4).each do |floor|
        objs = state[floor]
        generators = objs.select {|o| o.end_with? '-g'}.map {|o| o.split('-').first }
        microchips = objs.select {|o| o.end_with? '-m'}.map {|o| o.split('-').first }
        unmatched_chips = microchips - generators
        return true if !unmatched_chips.empty? && !generators.empty?
        # if !unmatched_chips.empty?
        #   return true if !(generators - microchips).empty?
        # end
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

    def find_solution
      # [elevator_pos, floor0 , ...]
      initial_state = [1] + DeepClone.clone(@floors)
      previous = Set.new(initial_state)
      queue = [initial_state]

      steps = 0
      while steps < 13 do
        new_queue = []
        puts "Step: #{steps} Possibilites: #{queue.length}" if @debug
        queue.each do |state|
          # return steps if we are in a success state

          # puts "#{steps} - State: #{state}" if @debug

          pos = state[0]
          objs = state[pos]
          combos = objs.to_a.combination(2) + objs.map {|o| [o]}
          [pos-1,pos+1].each do |new_floor|
            next if new_floor < 1 || new_floor > 4
            step_down = pos - 1 == new_floor
            step_up = !!step_down
            next if pos - 1 == new_floor && (1..new_floor).all? { |f| state[f].empty? }
            new_states = []
            combos.each do |combo|
              next if step_down && combo.count == 2
              next if step_up && !new_states.empty? && combo.count == 1
              new_state = DeepClone.clone(state)
              new_state[0] = new_floor
              new_state[pos] -= combo
              new_state[new_floor] += combo

              next if failure?(new_state)
              next if previous.include? new_state
              return steps + 1 if success?(new_state)
              previous.add state

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
