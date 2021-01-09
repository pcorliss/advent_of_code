require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Spring
    attr_accessor :debug
    attr_reader :program

    def initialize(input)
      @debug = false
      @program = Advent::IntCode.new(input)
    end

    def debug!
      @debug = true
    end

    def write_program(inp)
      to_program = inp + "WALK\n"
      to_program.chars.map(&:ord).each do |char|
        @program.program_input = char
      end
    end

    def run_and_output
      @program.run!
      acc = []
      until @program.full_output.empty? do
        acc << @program.output
      end
      acc.map do |char|
        char < 256 ? char.chr : char.to_s
      end.join('')
    end
  end
end
