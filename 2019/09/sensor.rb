require 'set'

module Advent

  class Sensor
    attr_accessor :debug

    def initialize(input)
      @debug = false
    end

    def debug!
      @debug = true
    end
  end

  class IntCode
    attr_reader :instructions, :inputs, :pos
    attr_accessor :debug

    def initialize(input)
      @instructions = input.split(",").map(&:to_i)
      @pos = 0
      @relative_base = 0
      @debug = false
      @inputs = []
      @paused = true
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
      # Opcode 9 adjusts the relative base by the value of its only parameter. The relative base increases (or decreases, if the value is negative) by the value of the parameter.
      9 => {
        arguments: 1,
        method: :relative,
      },
      99 => {
        arguments: 0,
        halt: true,
      },
    }

    def run!
      i = 0
      @paused = false
      while @pos < @instructions.length do
        opcode = @instructions[@pos] % 100
        instruction = INST[opcode]
        if instruction.nil?
          @pos += 1
          next
        end
        return if instruction[:halt]

        pos_params = instruction[:arguments].times.map do |i|
          mode = (@instructions[@pos] / 10 ** (i + 2)) % 10
          case mode
          when 2 # relative mode
            puts "Mode: #{mode} #{@pos} + #{i} + 1 + #{@relative_base} -- #{@instructions[@pos + i + 1 + @relative_base]}" if @debug
            (@instructions[@pos + i + 1] || 0) + @relative_base
          when 1 # immediate mode
            @pos + i + 1
          else # position mode
            puts "Mode: #{mode} #{@pos} + #{i} + 1 #{@instructions[@pos + i + 1]}" if @debug
            @instructions[@pos + i + 1] || 0
          end
        end

        puts "#{instruction[:method].inspect} - #{@pos} - #{pos_params} - #{@instructions[@pos..(@pos+instruction[:arguments])]}" if @debug
        break if instruction[:method] == :inp && @inputs.count == 0
        self.__send__(instruction[:method], @pos, *pos_params)
        @pos += instruction[:arguments] + 1
        i += 1
        raise "Too many iterations!!" if i > 1000000
      end
      @paused = true
    end

    def paused?
      !!@paused
    end

    def halted?
      # Not technically correct while running but sufficient for now
      !paused?
    end

    def equals(pos, x, y, z)
      a = @instructions[x] || 0
      b = @instructions[y] || 0
      result = 0
      result = 1 if a == b
      @instructions[z] = result
    end

    def less_than(pos, x, y, z)
      a = @instructions[x] || 0
      b = @instructions[y] || 0
      result = 0
      result = 1 if a < b
      @instructions[z] = result
    end

    # We can likely save some keystrokes here and swap the conditional around or something
    def jmp_if_false(pos, x, y)
      conditional = @instructions[x] || 0
      puts "Conditional: #{conditional}" if @debug
      if conditional == 0
        # We need to update the position a little bit more nicely
        @pos = (@instructions[y] || 0) - 3
      end
      puts "Pos: #{@pos}" if @debug
    end

    def jmp_if_true(pos, x, y)
      conditional = @instructions[x] || 0
      puts "Conditional: #{conditional}" if @debug
      if conditional != 0
        @pos = (@instructions[y] || 0) - 3
      end
      puts "Pos: #{@pos}" if @debug
    end


    def add(pos, x, y, z)
      a = @instructions[x] || 0
      b = @instructions[y] || 0
      @instructions[z] = a + b
    end

    def mult(pos, x, y, z)
      a = @instructions[x] || 0
      b = @instructions[y] || 0
      @instructions[z] = a * b
    end

    def inp(pos, x)
      @input_target = x
      @instructions[x] = program_input
    end

    def out(pos, x)
      @output_targets ||= []
      @output_targets << x
      puts "Output: #{@instructions[x]}" if @debug
    end

    def relative(pos, x)
      puts "Relative Base Adjusted: #{@relative_base} + #{@instructions[x]}" if @debug
      @relative_base += @instructions[x] || 0
    end

    def output
      @instructions[@output_targets.shift] || 0
    end

    # Unclear if we should be saving the output on assignment or if output is gauranteed not to be overwritten
    def full_output
      @output_targets.map do |t|
        @instructions[t] || 0
      end
    end
  end
end
