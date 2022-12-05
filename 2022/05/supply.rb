require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Supply
    attr_accessor :debug
    attr_reader :stacks, :instructions

    def initialize(input)
      @debug = false
      @instructions = []
      @stacks = []

      input.each_line do |line|
        line.chomp!
        if line.start_with? 'move'
          x, move, x, from, x, to = line.split(' ')
          @instructions.push({
            move: move.to_i,
            from: from.to_i,
            to: to.to_i,
          })
        else
          next if line.start_with? ' 1'
          line.chars.each_slice(4).each_with_index do |slice, idx|
            crate = slice[1]
            next if crate.empty? || crate == ' '
            @stacks[idx] ||= []
            @stacks[idx].push crate
          end
        end
      end

      @stacks.map! { |s| s.reverse }
    end

    def debug!
      @debug = true
    end

    def move!(instruction)
      instruction[:move].times do |i|
        from = instruction[:from] - 1
        to = instruction[:to] - 1
        crate = stacks[from].pop
        stacks[to].push(crate)
      end
    end

    def move_multi!(instruction)
        from = instruction[:from] - 1
        to = instruction[:to] - 1
        crates = []
        instruction[:move].times do |i|
          crates.push stacks[from].pop
        end
        stacks[to].concat(crates.reverse)
    end

    def run!
      instructions.each do |inst|
        move!(inst)
      end
    end

    def run_multi!
      instructions.each do |inst|
        move_multi!(inst)
      end
    end

    def top_of_stacks
      @stacks.map {|s| s.last }.join('')
    end
  end
end
