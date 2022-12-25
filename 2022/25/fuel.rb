require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Fuel
    attr_accessor :debug
    attr_reader :lines

    def initialize(input)
      @debug = false
      @lines = input.each_line.map(&:chomp!)
    end

    def debug!
      @debug = true
    end

    # 2, 1, 0, minus (written -), and double-minus (written =). Minus is worth -1, and double-minus is worth -2."
    SNAFU = {
      '2' => 2,
      '1' => 1,
      '0' => 0,
      '-' => -1,
      '=' => -2,
    }

    def convert_snafu(snafu)
      sum = 0
      snafu.chars.reverse.each_with_index do |char, idx|
        sum += SNAFU[char] * (5 ** idx)
      end
      sum
    end

    # '100' => 25
    # '10-' => 24
    # '10=' => 23
    # '1-2' => 22
    # '1-1' => 21
    # '1-0' => 20
    # '1--' => 19
    # '1-=' => 18
    # '1=2' => 17
    # '1=1' => 16
    # '1=0' => 15
    # '1=-' => 14
    # '1==' => 13
    # '22' => 12
    # '20' => 10
    # '2-' => 9
    # '2=' => 8
    # '12' => 7

    # '200' => 50
    # '2==' => 38 == 25 + 13 == 5**2 + 5**2 / 2 + 1
    # '122' => 37

    def convert_decimal(decimal)
      # power of 5 / 2 + 1
      # x**z == y
      # log x y = z

      sum = ''
      n = decimal

      max_exp = Math.log(n, 5).to_i + 1
      max_exp -= 1 if n <= (5**max_exp / 2)

      puts "Start: #{n}" if @debug
      puts "\t#{n}:#{sum} Exp: #{max_exp}" if @debug

      (max_exp + 1).times.to_a.reverse.each do |exp|
        if n >= 5**exp * 1.5
          n -= 5**exp * 2
          sum << '2'
        elsif n > 5**exp / 2
          n -= 5**exp
          sum << '1'
        elsif n.abs >= 5**exp * 1.5
          n += 5**exp * 2
          sum << '='
        elsif n.abs > 5**exp / 2
          n += 5**exp
          sum << '-'
        else
          sum << '0'
        end
        puts "\t#{n}:#{sum} Exp: #{exp}" if @debug
      end
    
      sum
    end

    def code
      sum = @lines.sum do |line|
        convert_snafu(line)
      end
      convert_decimal(sum)
    end
  end
end
