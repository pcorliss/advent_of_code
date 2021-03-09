require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Generators
    attr_accessor :debug
    attr_reader :generators

    def initialize(input)
      @debug = false
      @generators = []
      input.each_line.map do |line|
        line.chomp!
        if line =~ /^Generator . starts with (\d+)$/
          @generators << $1.to_i
        end
      end
    end

    def debug!
      @debug = true
    end

    FACTORS = [16807, 48271]
    MOD = 2147483647

    # previous value
    # multiplied by factor
    # modulo 2147483647

    def generate!
      @generators = @generators.each_with_index.map do |val, idx|
        (val * FACTORS[idx]) % MOD
      end
    end

    TWO_BYTES_MASK = 2 ** 16 - 1

    def match?
      a, b = @generators
      a & TWO_BYTES_MASK == b & TWO_BYTES_MASK
    end

    def sample(n)
      count = 0
      n.times do
        generate!
        count += 1 if match?
      end
      count
    end
  end
end
