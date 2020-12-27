require 'set'

module Advent

  class Seat

    attr_reader :seats, :width, :height

    def initialize(input, caching = false)
      @seats = input.lines.map {|l| l.chomp.chars }.flatten
      @width = input.lines.first.chars.count - 1
      @height = input.lines.count
      @caching = caching
      @positions = []
    end

    def edge?(pos, x_dir, y_dir)
      x = pos % width
      y = pos / width

      x + x_dir < 0 ||
      x + x_dir >= width ||
      y + y_dir < 0 ||
      y + y_dir >= height
    end

    def travel(pos, x_dir, y_dir)
      return nil if edge?(pos, x_dir, y_dir)
      new_pos = pos
      new_pos += x_dir
      new_pos += y_dir * width
      # puts "#{pos} -> #{new_pos} : #{seats[new_pos]} ! #{edge?(new_pos)}"
      return new_pos if seats[new_pos] != LAVA
      travel(new_pos, x_dir, y_dir)
    end

    def positions(pos)
      p = []
      p << travel(pos, -1, -1)
      p << travel(pos,  0, -1)
      p << travel(pos,  1, -1)
      p << travel(pos, -1,  0)
      p << travel(pos,  1,  0)
      p << travel(pos, -1,  1)
      p << travel(pos,  0,  1)
      p << travel(pos,  1,  1)
      p
    end

    def visible_seats(pos)
      if @caching
        @positions[pos] ||= positions(pos)
      else
        positions(pos)
      end.compact.map do |p|
        seats[p]
      end
    end

    def tick_prime!
      changes = 0
      new_seats = []
      seats.each_with_index do |s, idx|
        new_seats[idx] = s
        # puts "Start: #{s}" if idx == 0
        # puts "Visible: #{visible_seats(idx)}" if idx == 0
        next if s == LAVA
        if s == EMPTY && visible_seats(idx).count {|v| v == FILLED} == 0
          new_seats[idx] = FILLED
          changes += 1
        end
        if s == FILLED && visible_seats(idx).count {|v| v == FILLED} >= 5
          new_seats[idx] = EMPTY
          changes += 1
        end
        # puts "End: #{new_seats[idx]}" if idx == 0
      end

      @seats = new_seats
      changes
    end

    def stabilize_prime!
      # puts "STR Positions: #{@positions}"
      changes = 1
      i = 0
      # pr
      while changes > 0 do
        changes = tick_prime!
        # pr
        i += 1
        if i % 100 == 0
          puts "Breaking, too many iterations"
          break
        end
      end
      # puts "END Positions: #{@positions.count}"
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
