require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Monkey
    attr_accessor :debug
    attr_reader :instructions

    def initialize(input)
      @debug = false
      @instructions = {}
      input.each_line do |line|
        line.chomp!
        k, insts = line.split(': ')
        parts = insts.split(' ')
        @instructions[k.to_sym] = []
        parts.each do |part|
          if part =~ /^\d+$/
            @instructions[k.to_sym] << part.to_i
          else
            @instructions[k.to_sym] << part.to_sym
          end
        end
      end
    end

    def lookup(key)
      insts = @instructions[key]
      if insts.length == 1
        return insts.first
      else
        a, op, b = insts
        return lookup(a).__send__(op, lookup(b))
      end
    end

    def debug!
      @debug = true
    end
  end
end
