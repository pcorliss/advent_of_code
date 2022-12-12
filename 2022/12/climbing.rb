require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'
require 'timeout'

module Advent

  class Climbing
    attr_accessor :debug
    attr_reader :grid, :start, :end

    def initialize(input)
      @debug = false
      @grid = Grid.new(input)
      @start = @grid.find('S')
      @grid[@start] = 'a'
      @end = @grid.find('E')
      @grid[@end] = 'z'
    end

    def debug!
      @debug = true
    end

    def shortest_path(s = @start, e = @end)
      candidates = [[s]] 
      visited = Set.new [s]

      Timeout::timeout(6) do
        until candidates.empty? do
          puts "Candidates: #{candidates.count}" if @debug
          candidate = candidates.shift
          puts "\tCandidate: #{candidate}" if @debug
          current_cell = candidate.last
          current_val = @grid[candidate.last] 

          puts "\t#{current_cell} - #{current_val}" if @debug
          @grid.neighbor_coords(current_cell).each do |n|
            if !visited.include?(n) && @grid[n] && @grid[n].ord <= current_val.ord + 1
              # puts "\t#{!visited.include? n} && #{@grid[n]} && #{@grid[n].ord <= current_val.ord + 1}" if @debug
              new_candidate = candidate.clone
              new_candidate << n
              visited.add n

              return new_candidate if n == e
              candidates << new_candidate

              puts "\tNew Candidate added #{n} #{@grid[n]} - #{new_candidate}" if @debug
            end
          end
          raise "Failure!" if candidates.count > 100
        end
      end

      raise "Unable to find path" 
    end
  end
end
