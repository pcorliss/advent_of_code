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
      y = pos / width
      le = x == 0
      re = x == width - 1
      te = y == 0
      be = y == height - 1

      # puts "Edges: #{le} #{re} #{te} #{be}"
      acc = []
      acc.push seats[(pos - width - 1)] unless te || le
      # puts "TELE: #{acc}"
      acc.push seats[(pos - width)] unless te
      # puts "TE: #{acc}"
      acc.push seats[(pos - width + 1)] unless te || re
      # puts "TERE: #{acc}"
      acc.push seats[pos - 1] unless le
      # puts "LE: #{acc}"
      acc.push seats[pos + 1] unless re
      # puts "RE: #{acc}"
      acc.push seats[(pos + width - 1)] unless be || le
      # puts "BELE: #{acc}"
      acc.push seats[(pos + width)] unless be
      # puts "BE: #{acc}"
      acc.push seats[(pos + width + 1)] unless be || re
      # puts "BERE: #{acc}"
      acc
    end

    EMPTY = 'L'
    LAVA = '.'
    FILLED = '#'

    def tick!
      changes = 0
      new_seats = []
      seats.each_with_index do |s, idx|
        # puts "Start: #{s}" if idx == 91
        new_seats[idx] = s
        if s == EMPTY && adjacent_seats(idx).count {|v| v == FILLED} == 0
          new_seats[idx] = FILLED
          changes += 1
        end
        # puts "Adjacent: #{adjacent_seats(idx)}" if idx == 91
        if s == FILLED && adjacent_seats(idx).count {|v| v == FILLED} >= 4
          new_seats[idx] = EMPTY
          changes += 1
        end
        # puts "Finish: #{new_seats[idx]}" if idx == 91
      end

      # puts new_seats.first(92).join("")
      @seats = new_seats
      changes
    end

    def occupied_seats
      seats.count {|s| s == FILLED }
    end

    def pr
      print "\n\n\n"
      seats.each_with_index do |s, idx|
        if idx / width > 2
          break
        end
        print(s)
        print( "\n") if idx % width == width - 1
      end
    end

    def stabilize!
      changes = 1
      i = 0
      # pr
      while changes > 0 do
        changes = tick!
        # pr
        i += 1
        if i % 100 == 0
          break
        end
      end
    end
  end
end
