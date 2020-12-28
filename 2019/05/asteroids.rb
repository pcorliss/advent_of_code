require 'set'

module Advent

  class Asteroids
    attr_accessor :debug

    def initialize(input)
      @debug = false
    end

    def debug!
      @debug = true
    end
  end

  class IntCode
    attr_reader :instructions
    attr_accessor :debug

    def initialize(input)
      @instructions = input.split(",").map(&:to_i)
      @pos = 0
      @debug = false
    end

    def debug!
      @debug = true
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
        opcode = @instructions[@pos] % 100
        instruction = INST[opcode]
        if instruction.nil?
          @pos += 1
          next
        end
        break if instruction[:halt]

        params = instruction[:arguments].times.map do |i|
          (@instructions[@pos] / 10 ** (i + 2)) % (10 ** (i + 1)) == 1
        end

        self.__send__(instruction[:method], @pos, *params)
        @pos += instruction[:arguments] + 1
        i += 1
        raise "Too many iterations!!" if i > 100
      end
    end

    def add(pos, a_param, b_param, target_param)
      target = @instructions[pos + 3]
      a = @instructions[@instructions[pos + 1]]
      a = @instructions[pos + 1] if a_param
      b = @instructions[@instructions[pos + 2]]
      b = @instructions[pos + 2] if b_param
      @instructions[target] = a + b
    end

    def mult(pos, a_param, b_param, target_param)
      target = @instructions[pos + 3]
      a = @instructions[@instructions[pos + 1]]
      a = @instructions[pos + 1] if a_param
      b = @instructions[@instructions[pos + 2]]
      b = @instructions[pos + 2] if b_param
      @instructions[target] = a * b
    end
  end
end
