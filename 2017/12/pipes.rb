require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Pipes
    attr_accessor :debug
    attr_reader :pipe

    def initialize(input)
      @debug = false
      @pipe = {}
      input.each_line do |line|
        line.chomp!
        prog, connections = line.split(' <-> ')
        prog = prog.to_i
        @pipe[prog] ||= Set.new
        connections.split(', ').each do |conn|
          conn = conn.to_i
          @pipe[conn] ||= Set.new
          @pipe[conn] << prog
          @pipe[prog] << conn
        end
      end
    end

    def debug!
      @debug = true
    end

    def connected(prog)
      acc = Set.new
      acc << prog
      new_elements = Set.new([prog])
      i = 0
      until new_elements.empty? do
        puts "Acc: #{acc} New Elements: #{new_elements}" if @debug
        next_gen_elements = Set.new
        new_elements.each do |e|
          next_gen_elements |= @pipe[e]
        end
        new_elements = next_gen_elements - acc
        acc |= next_gen_elements
        i += 1
        raise "Too many iterations!!!" if i > 100
      end
      acc
    end

    def groups
      # acc = [[1], [0,2,3,4,5,6]]
      acc = []
      seen = Set.new
      @pipe.keys.each do |prog|
        next if seen.include? prog
        g = connected(prog)
        acc << g
        seen |= g
      end
      acc
    end
  end
end
