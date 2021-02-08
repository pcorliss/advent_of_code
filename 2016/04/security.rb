require 'set'
require '../lib/grid.rb'

module Advent

  class Security
    attr_accessor :debug
    attr_reader :rooms

    def initialize(input)
      @debug = false
      @rooms = input.lines.map(&:chomp)
    end

    def debug!
      @debug = true
    end

    ROOM_REGEX = /^([a-z\-]+)-(\d+)\[(\w+)\]$/

    def room_comp(room)
      if room =~ ROOM_REGEX
        return {
          encrypted: $1,
          sector_id: $2.to_i,
          checksum:$3,
        }
      end
      {}
    end

    def real?(room)
      encrypted, _, checksum = room_comp(room).values
      counts = {}
      encrypted.chars.each do |char|
        next if char == '-'
        counts[char] ||= 0
        counts[char] += 1
      end

      gen_sum = counts.keys.sort_by do |char|
        [counts[char] * -1, char]
      end

      puts "Counts: #{counts}" if @debug
      puts "GenSum: #{gen_sum}" if @debug
      puts "Checksum: #{checksum}" if @debug

      checksum == gen_sum.first(5).join
    end

    def decrypt(room)
      encrypted, sector_id, _ = room_comp(room).values
      offset = sector_id % 26
      encrypted.each_char.map do |char|
        if char == '-'
          " "
        else
          (((char.ord - 97) + offset) % 26 + 97).chr
        end
      end.join
    end
  end
end
