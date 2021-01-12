require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Packets
    attr_accessor :debug
    attr_reader :computers, :packets, :nat

    def initialize(input)
      @debug = false
      @computers = 50.times.map do |i|
        a = Advent::IntCode.new(input)
        a.program_input = i
        a
      end
      @packets = 50.times.map do |i|
        [i, -1]
      end
      @nat = nil
    end

    def run!
      if @packets.empty? && @nat
        @packets << @nat
        @packets.first[0] = 0
        puts "Packets Empty, Pushing NAT: #{@packets}"
      end
      addr, x, y = @packets.shift
      comp = @computers[addr]
      comp.program_input = x
      comp.program_input = y if y
      comp.run!
      while comp.outputs && !comp.outputs.empty? do
        @packets << 3.times.map { comp.output }
        @nat = @packets.pop if @packets.last.first == 255
      end
      @packets.last
    end

    def run_until_255
      i = 0
      until @nat || i > 1000 do
        run!
        i += 1
      end
      puts "Last Packet: #{@nat}"
      puts "Iterations: #{i}"
    end

    def run_until_packets_empty
      i = 0
      until @packets.empty? || i > 1000 do
        run!
        i += 1
      end
      puts "Nat: #{@nat}"
      puts "Iterations: #{i}"
    end

    def run_and_capture_nat
      i = 0
      nat_y = Set.new
      until i > 1000 do
        run!
        if @packets.empty? && @nat && nat_y.include?(@nat.last)
          puts "Found repeated Y: #{@nat.last}"
          break
        end
        nat_y.add @nat.last if @nat && @packets.empty?
        i += 1
      end
      puts "Iterations: #{i}"
    end

    def debug!
      @debug = true
    end
  end
end
