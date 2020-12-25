require 'set'

module Advent

  class Combo

    SUBJECT = 7
    DIVISOR = 20201227

    attr_reader :public_keys

    def initialize(input)
      @public_keys = input.each_line.map(&:chomp).map(&:to_i)
    end

    def loop_size(public_key)
      acc = 1
      lsize = 0
      until acc == public_key do
        # Set the value to itself multiplied by the subject number.
        acc *= SUBJECT
        # Set the value to the remainder after dividing the value by 20201227.
        acc %= DIVISOR
        raise "Too many iterations" if lsize > 200000000
        lsize += 1
      end
      lsize
    end

    def transform(subject, loop_size)
      acc = 1
      loop_size.times do |i|
        acc *= subject
        acc %= DIVISOR
      end
      acc
    end

    def encryption_key
      loop_sizes = @public_keys.map do |public_key|
        loop_size(public_key)
      end

      encryption_keys = @public_keys.zip(loop_sizes.rotate).map do |public_key, loop_size|
        transform(public_key, loop_size)
      end

      raise "Encryption Keys are different!: #{encryption_keys}" unless encryption_keys.uniq.count == 1
      encryption_keys.first
    end
  end
end
