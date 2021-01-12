require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Packets
    attr_accessor :debug
    attr_reader :computers

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
    end

    def run!
      addr, x, y = @packets.shift
      comp = @computers[addr]
      comp.program_input = x
      comp.program_input = y if y
      comp.run!
      while comp.outputs && !comp.outputs.empty? do
        @packets << 3.times.map { comp.output }
        return @packets.last if @packets.last.first == 255
      end
      @packets.last
    end

    def run_until_255
      last_packet = @packets.last
      i = 0
      until last_packet.first == 255 || i > 1000 do
        last_packet = run!
        i += 1
      end
      puts "Last Packet: #{last_packet}"
      puts "Iterations: #{i}"
    end

    def debug!
      @debug = true
    end
  end
end
