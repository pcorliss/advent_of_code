module Advent
  class CycleDetection
    attr_reader :results, :cycle_length, :cycle, :cycle_first_index
    attr_reader :min_cycle_length, :max_cycle_length, :min_repeats

    def initialize(min_repeats: 3, max_cycle_length: 30, min_cycle_length: 5, &block)
      raise ArgumentError.new("Must provide a block") unless block_given?
      @block = block
      @min_cycle_length = min_cycle_length
      @max_cycle_length = max_cycle_length
      @min_repeats = min_repeats
      @results = []
      @debug = false
    end

    def debug!
      @debug = true
    end

    def test_cycle?(cl)
      last_group = @results[-cl..-1]

      # Test each grouping if results
      (2..@min_repeats).all? do |i|
        @results[-(i)*cl..-(i-1)*cl-1] == last_group
      end
    end

    def cycle_finder(max_iterations = 1000)
      i = 0
      while i < max_iterations do
        i += 1
        @results << @block.call(@results.length)
        max_length = @results.length / @min_repeats
        max_length = @max_cycle_length if max_length > @max_cycle_length
        @cycle_length = (@min_cycle_length..max_length).find { |cl| test_cycle?(cl) }

        next unless @cycle_length

        @cycle = @results[-@cycle_length..-1]
        @cycle_first_index = @results.length - @min_repeats * @cycle_length
        return @cycle_length
      end

      nil
    end

    def [](index)
      return @results[index] if @results[index]

      results_index = (index - @cycle_first_index) % @cycle_length + @cycle_first_index
      @results[results_index]
    end
  end
end
