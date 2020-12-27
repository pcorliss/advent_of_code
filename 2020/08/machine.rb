require 'set'

module Advent

  class Machine
    attr_reader :inst

    def initialize(input)
      @inst = input.each_line.map do |line|
        cmd, val = line.chomp.split(" ")
        val = val.to_i
        [cmd, val]
      end
    end

    def run(instructions = inst, raise_error = false, acc = 0, idx = 0, visited = Set.new)
      while idx < instructions.length
        return [acc, true] if visited.include? idx
        visited.add idx
        instruction, val = instructions[idx]
        case instruction
        when "nop"
          idx += 1
        when "acc"
          acc += val
          idx += 1
        when "jmp"
          idx += val
        end
      end

      [acc, false]
    end

    def val_before_loop
      run.first
    end

    # The faster way to do this would be to visit "visited" in reverse order and walk back the state changing nop to jmps and vice versa. but we're doing it the inefficient way.
    def fix_jmp
      inst.each_with_index do |e, idx|
        next if e[0] == "acc"
        clone = inst.clone
        if e[0] == "nop"
          clone[idx] = ["jmp", e[1]]
        elsif e[0] == "jmp"
          clone[idx] = ["nop", e[1]]
        end
        acc = run(clone)
        # puts "Run: #{acc}, #{clone.inspect}"
        return acc.first if !acc.nil? && acc.last == false
      end
      nil
    end
  end
end
