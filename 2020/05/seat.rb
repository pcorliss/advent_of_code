require 'set'

module Advent

  class Five
    attr_reader :seats

    def initialize(input)
      @seats = {}
      input.each_line do |line|
        l = line.chomp
        @seats[l] = Seat.new(l)
        # puts "Instantiated #{@seats[l]} with #{l}"
      end
      # puts "Seats: #{seats.inspect}"
    end

    def max_seat_id
      @seats.values.map(&:seat_id).max
    end

    def missing_seat_id
      # sort, look for gap
      last_seat = nil
      @seats.values.sort_by(&:seat_id).each do |seat|
        if !last_seat.nil? && seat.seat_id - last_seat.seat_id > 1
          return seat.seat_id - 1
        end
        last_seat = seat
      end
    end
  end

  class Seat
    attr_reader :input

    def initialize(input)
      @input = input
      @bin = input
        .gsub("L", "0")
        .gsub("R", "1")
        .gsub("F", "0")
        .gsub("B", "1")
        .to_i(2)
    end

    def seat_id
      @bin
    end

    def col
      @bin & 7
    end

    def row
      @bin >> 3
    end
  end
end
