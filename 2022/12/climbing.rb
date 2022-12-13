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

    def shortest_path(s = [[@start]], e = @end)
      candidates = s
      visited = Set.new
      s.each do |paths|
        visited.add paths.first
      end

      Timeout::timeout(60) do
        until candidates.empty? do
          puts "Candidates: #{candidates.count}" if @debug
          candidate = candidates.shift
          puts "\tCandidate: #{candidate}" if @debug
          current_cell = candidate.last
          current_val = @grid[candidate.last] 
          # binding.pry if @debug

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
          raise "Too many candidates!" if candidates.count > 1_000
        end
      end

      raise "Unable to find path" 
    end

    def find_best_starting_position
      candidates = @grid.find_all('a').map do |cell|
        [cell]
      end
      puts "C: #{candidates}" if @debug
      shortest_path(candidates, @end).first
    end
  end
end
