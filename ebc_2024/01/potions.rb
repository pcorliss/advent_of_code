require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Potions
    attr_accessor :debug, :bugs

    # No potions are needed for the first A (Ancient Ant).
    # 1 potion is needed for the first B (Badass Beetle).
    # 1 potion is needed for the second B (Badass Beetle).
    # No potions are needed for the next A (Ancient Ant).
    # 3 potions are needed for the last monster, C (Creepy Cockroach).
    POTIONS = {
      "A" => 0,
      "B" => 1,
      "C" => 3
    }

    def initialize(input)
      @debug = false
      @bugs = input.chomp.chars.to_a
    end

    def debug!
      @debug = true
    end

    def potions
      POTIONS.values_at(*bugs).sum
    end
  end

  class Potions2
    attr_accessor :debug, :bugs, :group_size

    # No potions are needed for the first A (Ancient Ant).
    # 1 potion is needed for the first B (Badass Beetle).
    # 1 potion is needed for the second B (Badass Beetle).
    # No potions are needed for the next A (Ancient Ant).
    # 3 potions are needed for the last monster, C (Creepy Cockroach).
    POTIONS = {
      "A" => 0,
      "B" => 1,
      "C" => 3,
      "D" => 5,
      "x" => 0,
    }

    def initialize(input, group_size = 2)
      @debug = false
      @group_size = group_size
      @bugs = input.chomp.chars.each_slice(group_size).to_a
    end

    def debug!
      @debug = true
    end

    def potions
      @bugs.sum do |bug_group|
        sum = POTIONS.values_at(*bug_group).sum
        bug_count = bug_group.count { |bug| bug != "x" }
        sum += bug_count * (bug_count - 1) if bug_count > 1
        puts "Group: #{bug_group} #{bug_count} #{sum}" if @debug
        sum
      end
    end
  end
end
