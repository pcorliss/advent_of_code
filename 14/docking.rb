require 'set'

module Advent

  class Docking
    attr_reader :or_mask, :nand_mask, :memory, :memory_prime

    def initialize(input, mem_prime = false)
      @memory = Hash.new(0)
      @memory_prime = Hash.new(0)
      input.each_line do |line|
        opt, val = line.chomp.split(" = ")
        case opt
        when "mask"
          @or_mask = 0
          @nand_mask = 0
          @x_mask = []
          val.chars.reverse.each_with_index do |char, idx|
            case char
            when "1"
              @or_mask += 2**idx
            when "0"
              @nand_mask += 2**idx
            when "X"
              @x_mask << 2**idx
            end
          end

        when /mem\[(\d+)\]/
          addr = $1.to_i
          @memory[addr] = val.to_i
          # puts "#{addr} Val: #{@memory[addr]} #{@memory[addr].to_s(2)}"
          @memory[addr] &= ~@nand_mask
          # puts "#{addr} Val: #{@memory[addr]} #{@memory[addr].to_s(2)}"
          @memory[addr] |= @or_mask
          # puts "#{addr} Val: #{@memory[addr]} #{@memory[addr].to_s(2)}"

          set_memory_prime(addr | @or_mask, val.to_i, @x_mask) if mem_prime
          #@memory_prime[xaddr] = val.to_i
        end
      end
    end

    def set_memory_prime(addr, val, x_mask)
      if x_mask.empty?
        # puts "Setting #{addr} #{addr.to_s(2)} to #{val}"
        @memory_prime[addr] = val
      else
        bit = x_mask.first
        shift_mask = x_mask.slice(1..x_mask.length)
        set_memory_prime(addr & ~bit, val, shift_mask)
        set_memory_prime(addr |  bit, val, shift_mask)
      end
    end

    def sum
      @memory.values.inject(:+)
    end

    def sum_prime
      @memory_prime.values.inject(:+)
    end
  end
end
