require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Antenna
    attr_accessor :debug
    attr_reader :instructions, :registers, :pos, :out

    def initialize(input)
      @debug = false
      @registers = {
        a: 0,
        b: 0,
        c: 0,
        d: 0,
      }
      @pos = 0
      @instructions = input.each_line.map do |line|
        line.chomp!
        comps = line.split(" ")
        comps.map do |c|
          if c =~ /\d+/
            c.to_i
          else
            c.to_sym
          end
        end
      end
      @toggle = {}
      @out = []
    end

    def debug!
      @debug = true
    end

    def interpret(instruction)
      inst, a, b = instruction
      orig_inst = inst

      if @toggle[@pos]
        @toggle[@pos].times do
          case inst
          when :inc
            inst = :dec
          when :dec, :tgl
            inst = :inc
          when :jnz
            inst = :cpy
          when :cpy
            inst = :jnz
          end
        end
      end

      puts "\tToggled: #{inst} #{a} #{b}" if @debug && inst != orig_inst

      case inst
      when :cpy
        if b.is_a? Symbol
          if a.is_a? Symbol
            @registers[b] = @registers[a]
          else
            @registers[b] = a
          end
        end
      when :inc
        @registers[a] += 1
      when :dec
        @registers[a] -= 1
      when :jnz
        val = a
        val = @registers[a] if a.is_a? Symbol
        val_b = b
        val_b = @registers[b] if b.is_a? Symbol
        if val != 0
          @pos += val_b - 1
        end
      when :tgl
        val = a
        val = @registers[a] if a.is_a? Symbol
        @toggle[@pos + val] ||= 0
        @toggle[@pos + val] += 1
      when :add
        @registers[a] += @registers[b]
        @registers[b] = 0
      when :mul
        @registers[:a] = @registers[b] * @registers[a]
        @registers[b] = 0
      when :out
        val = a
        val = @registers[a] if a.is_a? Symbol
        @out << val
      end
      @pos += 1
    end

    def run!
      while @pos < @instructions.length do
        puts "#{' '*@pos}#{@pos}:\t#{@instructions[@pos]}\t#{@registers}\t#{@toggle}" if @debug
        interpret(@instructions[@pos])
      end
    end

    def run_with_check!(pattern, max = -1)
      while @pos < @instructions.length do
        puts "#{' '*@pos}#{@pos}:\t#{@instructions[@pos]}\t#{@registers}\t#{@toggle}" if @debug
        interpret(@instructions[@pos])
        @out.each_with_index do |o, idx|
          if pattern[idx % pattern.length] != o
            puts "Failed Pattern #{pattern} #{@out}"
            return -1
          end
        end
        break if max > 0 && @out.length > max
      end
      return 0
    end
  end
end
