require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Knots
    attr_accessor :debug
    attr_reader :lengths, :ring, :pos, :skip, :lengths_prime

    def initialize(input, ring_size = 256)
      @debug = false
      @lengths = input.split(',').map(&:to_i)
      # @ring = CircularLinkedList.new(ring_size.times.to_a)
      @ring = ring_size.times.to_a
      @pos = 0
      @skip = 0
      @lengths_prime = input.chomp.each_char.map(&:ord) + [17,31,73,47,23]
    end

    def debug!
      @debug = true
    end

    def twist!(num)
      new_pos = @pos + num
      reverse_range = (@pos...(@pos + (num / 2)))

      puts "Range: #{reverse_range} Starting Ring: #{@ring} Selection: #{num} NewPos: #{new_pos}" if @debug
      reverse_range.each do |i|
        offset = (new_pos - 1 - i + @pos) % @ring.length
        j = i % @ring.length
        tmp = @ring[j]
        @ring[j] = @ring[offset]
        @ring[offset] = tmp
        # raise "Nil!!!" if @ring[j].nil? || @ring[offset].nil?

        puts "Ring: #{@ring} I: #{i} Offset: #{offset}" if @debug
      end

      @pos = (new_pos + @skip) % @ring.length
      @skip += 1
    end

    def run!
      @lengths.each do |l|
        twist!(l)
        # raise "Nil encountered" if ring.include? nil
        # raise "Dupe" if ring.uniq.length != ring.length
      end
    end

    def dense_hash
      @ring.each_slice(16).map do |slice|
        slice.inject(:^)
      end
    end

    def to_hex
      dense_hash.map {|h| "%02x" % h }.join
    end

    def run_prime!
      64.times do
        @lengths_prime.each do |l|
          twist!(l)
        end
      end
    end
  end
end
