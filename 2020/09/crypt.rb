require 'set'

module Advent

  class Crypt
    attr_reader :nums

    def initialize(input, preamble_length = 5)
      @nums = input.each_line.map(&:to_i)
      @preamble_length = preamble_length
    end

    def compliment_set(pos)
      num = nums[pos]
      Set.new preamble(pos).map { |n| num - n }
    end

    def preamble(pos)
      Set.new(nums[(pos-@preamble_length)...pos])
    end

    def valid?(pos)
      p = preamble(pos)
      c = compliment_set(pos)
      !(c & p).empty?
    end

    def first_invalid_num
      invalid_pos = (@preamble_length...@nums.length).find do |pos|
        !valid?(pos)
      end

      @nums[invalid_pos]
    end

    def contigous_weakness(num)
      @nums.length.times do |start_pos|
        acc = 0
        pos = start_pos
        while acc < num do
          acc += @nums[pos]
          # puts "#{start_pos} #{pos} #{@nums[pos]} #{acc} #{num}"
          pos += 1
        end
        if acc == num
          return @nums[start_pos...pos]
        end
      end
      []
    end

    def sum_first_last_contig(num) 
      weak = contigous_weakness(num).sort
      weak.first + weak.last
    end
  end
end
