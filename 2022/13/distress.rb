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

    def user_compare(left, right)
      left.each_with_index do |l, idx|
        r = right[idx]
        puts "Compare #{l} #{r}" if @debug

        return 1 if r.nil?
        # return -1 if l.nil?

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

    def compare_pair(left, right)
      comp = left <=> right
      return comp unless comp.nil?

      left.zip(right).each do |l, r|
        comp = l <=> r
        next if !comp.nil? && comp.zero?
        return comp unless comp.nil?

        comp = compare_pair([l], r) if !l.is_a?(Array) && r.is_a?(Array)
        comp = compare_pair(l, [r]) if l.is_a?(Array) && !r.is_a?(Array)
        comp = compare_pair(l, r) if l.is_a?(Array) && r.is_a?(Array)

        return 1 if r.nil?

        puts "Failure Comparing: #{left} #{right} #{left.zip(right)}" if comp.nil? && @debug
        puts "Failure Comparing: #{l} #{r}" if comp.nil? && @debug
        raise "Bad Comparison #{l} #{r}" if comp.nil?
        return comp unless comp.zero?
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

    def add_divider_packets!
      @pairs << [[[2]], [[6]]]
    end

    def sorted_packets
      add_divider_packets!
      packets = []
      @pairs.each do |left, right|
        packets << left
        packets << right
      end

      packets.sort do |a, b|
        begin
          compare_pair(a, b)
        rescue => e
          puts "Error comparing #{a} #{b}"
          raise e
        end
      end
    end

    def decoder_key
      sorted = sorted_packets
      a = sorted.index([[2]]) + 1
      b = sorted.index([[6]]) + 1
      a * b
    end
  end
end
