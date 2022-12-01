require 'set'

module Advent

  class Calories
    attr_reader :elves

    def initialize(input)
      @elves = []
      current_elf = 0
      input.lines.each do |line|
        line.chomp!
        elf = @elves[current_elf] ||= []
        if line.empty?
          current_elf += 1
          next
        end
        elf << line.to_i
      end
    end

    def most_calories
      @elves.map(&:sum).max
    end

    def top_three_calories
      @elves.map(&:sum).sort.last(3).sum
    end
  end
end
