require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

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
        @blueprints << {id: id.to_i, starting_robots: {ore: 1}}
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
  end
end
