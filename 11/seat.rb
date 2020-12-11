require 'set'

module Advent

  class Seat

    attr_reader :seats, :width, :height

    def initialize(input)
      @seats = input.lines.map {|l| l.chomp.chars }.flatten
      @width = input.lines.first.chars.count - 1
      @height = input.lines.count
    end

    def adjacent_seats(pos)
      x = pos % width
      y = pos / height
      le = x == 0
      re = x == width - 1
      te = y == 0
      be = y == height - 1

      #puts "Edges: #{le} #{re} #{te} #{be}"
      acc = []
      acc.push seats[(pos - height - 1)] unless te || le
      #puts "TELE: #{acc}"
      acc.push seats[(pos - height)] unless te
      #puts "TE: #{acc}"
      acc.push seats[(pos - height + 1)] unless te || re
      #puts "TERE: #{acc}"
      acc.push seats[pos - 1] unless le
      #puts "LE: #{acc}"
      acc.push seats[pos + 1] unless re
      #puts "RE: #{acc}"
      acc.push seats[(pos + height - 1)] unless be || le
      #puts "BELE: #{acc}"
      acc.push seats[(pos + height)] unless be
      #puts "BE: #{acc}"
      acc.push seats[(pos + height + 1)] unless be || re
      #puts "BERE: #{acc}"
      acc
    end

    EMPTY = 'L'
    LAVA = '.'
    FILLED = '#'

    def tick!
      changes = 0
      new_seats = []
      seats.each_with_index do |s, idx|
        new_seats[idx] = s
        if s == EMPTY && adjacent_seats(idx).count {|v| v == FILLED} == 0
          new_seats[idx] = FILLED
          changes += 1
        end
        if s == FILLED && adjacent_seats(idx).count {|v| v == FILLED} >= 4
          new_seats[idx] = EMPTY
          changes += 1
        end
      end

      @seats = new_seats
      changes
    end

    def occupied_seats
      seats.count {|s| s == FILLED }
    end
  end
end
