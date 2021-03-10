require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Dancing
    attr_accessor :debug, :line
    attr_reader :inst

    def initialize(input)
      @debug = false
      @line = ('a'..'p').to_a
      @inst = []
      input.chomp.split(',').each do |instruction|
        typ = nil
        a = nil
        b = nil
        case instruction[0]
        when 's'
          typ = :spin
          a = instruction[1..].to_i
        when 'x'
          typ = :exchange
          a, b = instruction[1..].split('/').map(&:to_i)
        when 'p'
          typ = :partner
          a, b = instruction[1..].split('/')
        end
        inst = [typ, a, b].compact
        @inst << inst
      end
    end

    def debug!
      @debug = true
    end

    def spin(n)
      @line.rotate!(-n)
    end

    def exchange(i, j)
      tmp = @line[i]
      @line[i] = @line[j]
      @line[j] = tmp
    end

    def partner(a, b)
      i = @line.index(a)
      j = @line.index(b)
      exchange(i, j)
    end

    def run!
      @inst.each do |inst|
        self.__send__(*inst)
      end
    end

    def find_cycle!
      @states = {}
      @state_lookup = {}
      i = 0
      loop do
        if @states.has_key? @line.join
          break
        end
        @states[@line.join] = i
        @state_lookup[i] = @line.join
        i += 1
        run!
      end
      i
    end

    def line_after(n)
      cycle = find_cycle!
      @state_lookup[n % cycle]
    end
  end
end
