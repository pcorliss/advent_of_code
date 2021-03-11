require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Duet
    attr_accessor :debug
    attr_reader :pos, :instructions, :last_sound, :registers

    def initialize(input)
      @debug = false
      @pos = 0
      @halt = false
      @registers = Hash.new(0)
      @instructions = input.each_line.map do |line|
        line.chomp!
        line.split(' ').map do |segment|
          if segment =~ /^[a-z]*$/
            segment.to_sym
          else
            segment.to_i
          end
        end
      end
    end

    def debug!
      @debug = true
    end

    def run_inst(inst, a, b = nil)
      b = @registers[b] if b.is_a?(Symbol)
      case inst
      when :snd
        @last_sound = @registers[a]
      when :set
        @registers[a] = b
      when :add
        @registers[a] += b
      when :mul
        @registers[a] *= b
      when :mod
        @registers[a] %= b
      when :rcv
        unless @registers[a].zero?
          @registers[a] = @last_sound
          @halt = true
        end
      when :jgz
        @pos += b - 1 if @registers[a] > 0
      end
      @pos += 1
      puts "#{@pos} - #{inst}, #{a}, #{b}, - #{@registers}" if @debug
    end

    def halt?
      @halt || @pos < 0 || @pos > @instructions.length
    end

    def run!
      until halt? do
        run_inst(*@instructions[@pos])
      end
    end
  end

  class DuetPrime
    attr_accessor :debug
    attr_reader :pos, :instructions, :last_sound, :registers, :outbox, :inbox, :deadlock

    def initialize(input, prog_id = 0)
      @debug = false
      @pos = 0
      @halt = false
      @registers = Hash.new(0)
      @registers[:p] = prog_id
      @outbox = []
      @inbox = []
      @deadlock = false
      @instructions = input.each_line.map do |line|
        line.chomp!
        line.split(' ').map do |segment|
          if segment =~ /^[a-z]*$/
            segment.to_sym
          else
            segment.to_i
          end
        end
      end
    end

    def debug!
      @debug = true
    end

    def run_inst(inst, a, b = nil)
      b = @registers[b] if b.is_a?(Symbol)
      val_a = a.is_a?(Symbol) ? @registers[a] : a

      case inst
      when :snd
        @outbox << val_a
      when :set
        @registers[a] = b
      when :add
        @registers[a] += b
      when :mul
        @registers[a] *= b
      when :mod
        @registers[a] %= b
      when :rcv
        if @inbox.empty?
          @deadlock = true
          @pos -= 1
        else
          @deadlock = false
          @registers[a] = @inbox.shift
        end
      when :jgz
        @pos += b - 1 if val_a > 0
      else
        raise "Unhandled instruction #{inst}"
      end
      @pos += 1
      puts "#{@pos} - #{inst}, #{a}, #{b}, - #{@registers} - Out: #{outbox} - In: #{inbox}" if @debug
    end

    def halt?
      @halt || @pos < 0 || @pos > @instructions.length
    end

    def run!
      puts "#{@pos} - #{@registers} - Out: #{outbox} - In: #{inbox}" if @debug
      @deadlock = false
      until halt? || @deadlock do
        run_inst(*@instructions[@pos])
      end
    end

    def self.deadlocked?(p0, p1)
      p0.inbox.empty? &&
      p1.inbox.empty? &&
      p0.deadlock &&
      p1.deadlock
    end

    def self.run!(input, debug: false)
      p0 = new(input, 0)
      p1 = new(input, 1)
      if debug
        p0.debug!
        p1.debug!
      end

      counts = [0, 0]
      i = 0
      until p0.halt? || p1.halt? || deadlocked?(p0, p1) do
        p0.run!
        p1.run!
        until p0.outbox.empty?
          p1.inbox << p0.outbox.shift
          counts[0] += 1
        end
        until p1.outbox.empty?
          p0.inbox << p1.outbox.shift
          counts[1] += 1
        end
        i += 1
        raise "Too many iterations!!! #{i}" if i > 10000
      end

      counts
    end
  end
end
