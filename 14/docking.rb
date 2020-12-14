require 'set'

module Advent

  class Docking
    attr_reader :or_mask, :nand_mask, :memory

    def initialize(input)
      @memory = Hash.new(0)
      input.each_line do |line|
        opt, val = line.chomp.split(" = ")
        case opt
        when "mask"
          @or_mask = 0
          @nand_mask = 0
          val.chars.reverse.each_with_index do |char, idx|
            case char
            when "1"
              @or_mask += 2**idx
            when "0"
              @nand_mask += 2**idx
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
        end
      end
    end

    def sum
      @memory.values.inject(:+)
    end
  end
end
