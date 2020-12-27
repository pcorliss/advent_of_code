require 'set'

module Advent

  class Rocket
    attr_reader :masses

    def initialize(input)
      @masses = input.lines.map { |l| l.chomp.to_i }
    end

    def fuel(mass)
      f = (mass / 3) - 2
      [f, 0].max
    end

    def total_fuel
      @masses.sum do |mass|
        fuel(mass)
      end
    end

    def total_recursive_fuel
      @masses.sum do |mass|
        recursive_fuel(mass)
      end
    end

    def recursive_fuel(mass)
      f = mass
      acc = 0
      until f == 0 do
        f = fuel(f)
        acc += f
      end
      acc
    end
  end
end
