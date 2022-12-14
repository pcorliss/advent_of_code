require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'json'

module Advent

  class Distress
    attr_accessor :debug
    attr_reader :pairs

    def initialize(input)
      @debug = false
      @pairs = [[]]
      current_pair = @pairs.last
      input.each_line do |line|
        line.chomp!
        if line.empty?
          @pairs << []
          current_pair = @pairs.last
          next
        end

        current_pair << JSON.parse(line)
      end
    end

    def debug!
      @debug = true
    end

    def compare_pair(left, right)
      left.each_with_index do |l, idx|
        r = right[idx]
        puts "Compare #{l} #{r}" if @debug

        return 1 if r.nil?

        val = compare_pair([l], r) if r.is_a?(Array) && !l.is_a?(Array)
        val = compare_pair(l, [r]) if !r.is_a?(Array) && l.is_a?(Array)
        val = compare_pair(l, r) if r.is_a?(Array) && l.is_a?(Array)

        next if val == -1
        return 1 if val == 1
        return 1 if r < l
        return -1 if l < r
      end
      -1
    end

    def idx_of_pairs_in_right_order
      indexes = []
      pairs.each_with_index do |pair, idx|
        left, right = pair
        indexes << idx + 1 if compare_pair(left, right) == -1
      end
      indexes
    end
  end
end
