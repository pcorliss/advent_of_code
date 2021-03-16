require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Bridge
    attr_accessor :debug
    attr_reader :comps, :comp_lookup

    def initialize(input)
      @debug = false
      @comp_lookup = {}
      @comps = input.each_line.map do |line|
        line.chomp!
        a, b = line.split('/')
        e = [a.to_i, b.to_i]
        @comp_lookup[a.to_i] ||= []
        @comp_lookup[b.to_i] ||= []
        @comp_lookup[a.to_i] << e
        @comp_lookup[b.to_i] << e
        @comp_lookup[a.to_i].uniq!
        @comp_lookup[b.to_i].uniq!
        e
      end
    end

    def debug!
      @debug = true
    end

    def valid_parts(used_parts, pins)
      @comp_lookup[pins] - used_parts
    end

    def strength(parts)
      parts.flatten.sum
    end

    def bridges
      return @finished_bridges if @finished_bridges
      @finished_bridges = []
      in_progress_bridges = []
      working_bridge = []
      working_pin = 0
      in_progress_bridges << [working_bridge, working_pin]

      i = 0
      loop do
        new_in_progress = []
        puts "#{i} - InProgress: #{in_progress_bridges.count}" if @debug
        in_progress_bridges.each do |working_bridge, working_pin|
          potentials = valid_parts(working_bridge, working_pin)
          @finished_bridges << working_bridge unless working_bridge.empty?
          # puts "\tPotentials: #{potentials}" if @debug
          potentials.each do |potential|
            a, b = potential
            new_pin = a == working_pin ? b : a
            # puts "\t\tNew In Progress Bridge - #{working_bridge} #{potential} #{new_pin}" if @debug
            new_in_progress << [working_bridge + [potential], new_pin]
          end
        end

        in_progress_bridges = new_in_progress
        break if in_progress_bridges.empty?

        i += 1
        raise "Too many iterations!!! #{i}" if i > 100
      end

      @finished_bridges
    end

    def strongest_bridge
      bridges.max_by do |b|
        strength(b)
      end
    end

    def longest_bridge
      bridges.max_by do |b|
        b.length * 100 + strength(b)
      end
    end
  end
end
