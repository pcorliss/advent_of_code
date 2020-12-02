require 'set'

module Advent
  class Two
    attr_reader :input

    def initialize(input)
      @input = Set.new
      input.each_line do |line|
        if line =~ /(\d+)-(\d+)\s(.): (.*)$/
          @input.add [($1.to_i..$2.to_i), $3, $4]
        end
      end
    end

    def valid_password?(range, char, password)
      count = password.each_char.count do |c|
        c == char
      end
      range.include? count
    end

    def valid_password_count
      @input.count do |e|
        valid_password?(*e)
      end
    end
  end

  class TwoPartTwo
    attr_reader :input

    def initialize(input)
      @input = Set.new
      input.each_line do |line|
        if line =~ /(\d+)-(\d+)\s(.): (.*)$/
          @input.add [$1.to_i, $2.to_i, $3, $4]
        end
      end
    end

    def valid_password?(valid_idx, invalid_idx, char, password)
      password[valid_idx-1] == char && password[invalid_idx-1] != char
    end

    def valid_password_count
      @input.count do |e|
        valid_password?(*e)
      end
    end
  end
end
