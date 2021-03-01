require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Debugger
    attr_accessor :debug
    attr_reader :blocks

    def initialize(input)
      @debug = false
      @blocks = input.split(/\s+/).map(&:to_i)
    end

    def debug!
      @debug = true
    end

    def redist!
      largest_block = -1
      largest_index = -1
      @blocks.each_with_index do |block, idx|
        if block > largest_block
          largest_index = idx
          largest_block = block
        end
      end

      puts "Largest: #{largest_block} #{largest_index} - #{@blocks}" if @debug
      @blocks[largest_index] = 0
      index = largest_index + 1
      largest_block.times do
        @blocks[index % @blocks.length] += 1
        index += 1
      end
    end

    def run!
      steps = 0
      states = Set.new
      states.add @blocks.hash
      loop do
        redist!
        steps += 1
        puts "Steps: #{steps} Blocks: #{blocks}" if @debug
        return steps if states.include? @blocks.hash
        states.add @blocks.hash
        raise "Too many iterations!!!" if steps > 100000
      end
    end
  end
end
