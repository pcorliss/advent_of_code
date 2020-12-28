require 'set'

module Advent

  class Password
    attr_accessor :debug, :range

    def initialize(input)
      @debug = false
      st, en = input.split("-").map(&:to_i)
      @range = (st..en)
      # puts "Range: #{@range.inspect}" if @debug
    end

    DOUBLES = %w(11 22 33 44 55 66 77 88 99 00)
    DOUBLES_REGEX = /(11|22|33|44|55|66|77|88|99|00)/
    def valid_numbers
      s = Set.new
      st = [@range.min, 100_000].max
      en = [@range.max, 999_999].min
      (st..en).each do |i|
        # Is the regex fast enough?
        if i.to_s.match(DOUBLES_REGEX)
          last = 10
          increasing = i.digits.all? do |digit|
            if digit <= last
              last = digit
            end
          end
          s.add i if increasing
        end
      end
      s
    end

    def valid_numbers_prime
      s = valid_numbers
      s.each do |i|
        puts "Num: #{i}" if @debug
        last_digit = 10
        repeats = {}
        i.digits.each do |j|
          if last_digit == j
            repeats[j] ||= 0
            repeats[j] += 1
          end
          last_digit = j
        end
        puts "Repeats: #{repeats.inspect}" if @debug
        s.delete i unless repeats.values.include? 1
      end
      s
    end
  end
end
