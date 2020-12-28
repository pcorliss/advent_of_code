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

    # It is a six-digit number.
    # The value is within the range given in your puzzle input.
    # Two adjacent digits are the same (like 22 in 122345).
    # Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
  end
end
