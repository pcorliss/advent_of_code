require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Hotsprings
    attr_accessor :debug
    attr_reader :springs, :counts

    def initialize(input)
      @debug = false

      @springs = []
      @counts = []
      input.lines.each do |line|
        spring, counts = line.split(' ')
        @springs << spring.chars
        @counts << counts.split(',').map(&:to_i)
      end
    end

    def debug!
      @debug = true
    end

    def cont_match?(spring, count)
      spring.join.split('.').reject(&:empty?).map(&:length) == count
    end

    def arrangements(spring, count)
      possible = 0
      missing_spaces = spring.count('?')
      puts "Missing spaces: #{missing_spaces} for #{spring} and #{count}" if @debug
      ['.','#'].repeated_permutation(missing_spaces).each do |perm|
        new_spring = spring.map { |c| c == '?' ? perm.shift : c }
        possible += 1 if cont_match?(new_spring, count)
      end
      possible
    end

    def possible_arrangements
      @springs.zip(@counts).sum do |spring, count|
        arrangements(spring, count)
      end
    end
  end
end
