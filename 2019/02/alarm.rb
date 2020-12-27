require 'set'

module Advent

  class Alarm
    attr_reader :instructions

    def initialize(input)
      @instructions = input.split(",").map(&:to_i)
      @pos = 0
    end

    INST = {
      1 => {
        arguments: 3,
        method: :add,
      },
      2 => {
        arguments: 3,
        method: :mult,
      },
      99 => {
        :halt => true,
      },
    }

    def run!
      i = 0
      while @pos < @instructions.length do
        instruction = INST[@instructions[@pos]]
        if instruction.nil?
          @pos += 1
          next
        end
        break if instruction[:halt]
        self.__send__(instruction[:method], @pos)
        @pos += instruction[:arguments] + 1
        i += 1
        raise "Too many iterations!!" if i > 100
      end
    end

    def add(pos)
      target = @instructions[pos + 3]
      a = @instructions[@instructions[pos + 1]]
      b = @instructions[@instructions[pos + 2]]
      @instructions[target] = a + b
    end

    def mult(pos)
      target = @instructions[pos + 3]
      a = @instructions[@instructions[pos + 1]]
      b = @instructions[@instructions[pos + 2]]
      @instructions[target] = a * b
    end
  end
end
