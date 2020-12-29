require 'set'

module Advent

  class Amp
    attr_accessor :debug

    def initialize(input)
      @debug = false
    end

    def debug!
      @debug = true
    end
  end

  class IntCode
    attr_reader :instructions, :inputs
    attr_accessor :debug

    def initialize(input)
      @instructions = input.split(",").map(&:to_i)
      @pos = 0
      @debug = false
      @inputs = []
    end

    def program_input
      @inputs.shift
    end

    def program_input=(inp)
      @inputs << inp
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
      # Opcode 3 takes a single integer as input and saves it to the position given by its only parameter. For example, the instruction 3,50 would take an input value and store it at address 50.
      3 => {
        arguments: 1,
        method: :inp,
      },
      # Opcode 4 outputs the value of its only parameter. For example, the instruction 4,50 would output the value at address 50.
      4 => {
        arguments: 1,
        method: :out,
      },
      # Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
      5 => {
        arguments: 2,
        method: :jmp_if_true,
      },
      # Opcode 6 is jump-if-false: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
      6 => {
        arguments: 2,
        method: :jmp_if_false,
      },
      # Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
      7 => {
        arguments: 3,
        method: :less_than,
      },
      # Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
      8 => {
        arguments: 3,
        method: :equals,
      },
      99 => {
        arguments: 0,
        halt: true,
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

        puts "#{instruction[:method].inspect} - #{@pos} - #{params} - #{@instructions[@pos..(@pos+instruction[:arguments])]}" if @debug
        self.__send__(instruction[:method], @pos, *params)
        @pos += instruction[:arguments] + 1
        i += 1
        raise "Too many iterations!!" if i > 1000
      end
    end

    def equals(pos, a_param, b_param, target_param)
      target = @instructions[pos + 3]
      a = @instructions[@instructions[pos + 1]]
      a = @instructions[pos + 1] if a_param
      b = @instructions[@instructions[pos + 2]]
      b = @instructions[pos + 2] if b_param
      result = 0
      result = 1 if a == b
      @instructions[target] = result
    end

    def less_than(pos, a_param, b_param, target_param)
      target = @instructions[pos + 3]
      a = @instructions[@instructions[pos + 1]]
      a = @instructions[pos + 1] if a_param
      b = @instructions[@instructions[pos + 2]]
      b = @instructions[pos + 2] if b_param
      result = 0
      result = 1 if a < b
      @instructions[target] = result
    end

    # We can likely save some keystrokes here and swap the conditional around or something
    def jmp_if_false(pos, cond_param, val_param)
      puts "#{pos} - #{cond_param} - #{val_param}" if @debug
      conditional = @instructions[@instructions[pos + 1]]
      conditional = @instructions[pos + 1] if cond_param
      puts "Conditional: #{conditional}" if @debug
      if conditional == 0
        # We need to update the position a little bit more nicely
        @pos = @instructions[@instructions[pos + 2]] - 3
        @pos = @instructions[pos + 2] - 3 if val_param
      end
      puts "Pos: #{@pos}" if @debug
    end

    def jmp_if_true(pos, cond_param, val_param)
      puts "#{pos} - #{cond_param} - #{val_param}" if @debug
      conditional = @instructions[@instructions[pos + 1]]
      conditional = @instructions[pos + 1] if cond_param
      puts "Conditional: #{conditional}" if @debug
      if conditional != 0
        # We need to update the position a little bit more nicely
        @pos = @instructions[@instructions[pos + 2]] - 3
        @pos = @instructions[pos + 2] - 3 if val_param
      end
      puts "Pos: #{@pos}" if @debug
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

    # Will I ever need to deal with immediate mode?
    def inp(pos, target_param)
      @input_target = @instructions[pos + 1]
      @input_target = pos + 1 if target_param
      @instructions[@input_target] = program_input
    end

    def out(pos, target_param)
      @output_target = @instructions[pos + 1]
      @output_target = pos + 1 if target_param
    end

    def output
      @instructions[@output_target]
    end
  end
end
